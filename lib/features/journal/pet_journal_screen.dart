import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_journal_entry.dart';
import 'journal_controller.dart';

class PetJournalScreen extends StatelessWidget {
  final JournalController controller;
  const PetJournalScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('journal'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntrySheet(context, t),
        icon: const Icon(Icons.add),
        label: Text(t('add_entry')),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: StreamBuilder<List<PetJournalEntry>>(
          stream: controller.entriesStream,
          builder: (context, snapshot) {
            if (controller.isLoading) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Skeleton(height: 120, width: double.infinity),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: 3,
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(child: Text(t('empty_journal')));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) {
                final entry = items[i];
                return _JournalCard(entry: entry, timeLabel: _timeAgo(entry.createdAt, t))
                    .animate(delay: (90 * i).ms)
                    .fadeIn()
                    .slide(begin: const Offset(0, 0.05));
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context, String Function(String) t) {
    final petCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String selectedMood = '🐾';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: StatefulBuilder(builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('add_entry'), style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: petCtrl,
                    decoration: InputDecoration(labelText: t('pet_name_hint')),
                  ),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(labelText: t('title')),
                  ),
                  TextField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: t('notes_hint')),
                  ),
                  const SizedBox(height: 12),
                  Text(t('mood')),
                  Wrap(
                    spacing: 10,
                    children: ['🐾', '😊', '💪', '🩺', '😴'].map((m) {
                      final isSelected = selectedMood == m;
                      return ChoiceChip(
                        label: Text(m),
                        selected: isSelected,
                        onSelected: (_) => setState(() => selectedMood = m),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addEntry(
                          petName: petCtrl.text.isEmpty ? t('unknown_pet') : petCtrl.text,
                          title: titleCtrl.text.isEmpty ? t('untitled') : titleCtrl.text,
                          note: noteCtrl.text,
                          mood: selectedMood,
                        );
                        Navigator.pop(ctx);
                      },
                      child: Text(t('save')),
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String _timeAgo(DateTime time, String Function(String) t) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return t('just_now');
    if (diff.inHours < 1) return '${diff.inMinutes} ${t('minutes_ago')}';
    if (diff.inHours < 24) return '${diff.inHours} ${t('hours_ago')}';
    return '${diff.inDays} ${t('days_ago')}';
  }
}

class _JournalCard extends StatelessWidget {
  final PetJournalEntry entry;
  final String timeLabel;
  const _JournalCard({required this.entry, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entry.mood, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text(timeLabel, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          Text(entry.petName, style: TextStyle(color: Theme.of(context).primaryColor)),
          const SizedBox(height: 8),
          Text(entry.note),
        ],
      ),
    );
  }
}
