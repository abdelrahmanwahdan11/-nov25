import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/daily_checkin.dart';
import 'daily_checkin_controller.dart';

class DailyCheckinScreen extends StatefulWidget {
  final DailyCheckinController controller;
  const DailyCheckinScreen({super.key, required this.controller});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  final _titleCtrl = TextEditingController();
  final _petCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _mood = 'calm';

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _petCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('daily_checkins')),
        actions: [
          IconButton(onPressed: widget.controller.load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openComposer,
        icon: const Icon(Icons.checklist_rtl_rounded),
        label: Text(t('add_checkin')),
      ),
      body: StreamBuilder<List<DailyCheckin>>(
        stream: widget.controller.itemsStream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (widget.controller.isLoading && items.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: Skeleton(height: 92, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _CheckinCard(
                  item: item,
                  onToggle: () => widget.controller.toggleComplete(item),
                ).animate().fadeIn(duration: 360.ms, delay: (40 * index).ms).slideY(begin: 0.06);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openComposer() async {
    final t = AppLocalizations.of(context).t;
    _titleCtrl.clear();
    _petCtrl.clear();
    _noteCtrl.clear();
    _mood = 'calm';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(t('add_checkin'), style: Theme.of(context).textTheme.titleMedium)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: t('checkin_title_hint'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _petCtrl,
                decoration: InputDecoration(
                  hintText: t('pet_name_hint'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              Text(t('mood'), style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['calm', 'excited', 'focused', 'sleepy', 'playful'].map((m) {
                  final selected = _mood == m;
                  return ChoiceChip(
                    label: Text(m),
                    selected: selected,
                    onSelected: (_) => setState(() => _mood = m),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: t('note_optional'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_task_rounded),
                  label: Text(t('save')),
                  onPressed: () {
                    widget.controller.addQuick(
                      _titleCtrl.text.trim().isEmpty ? t('quick_checkin') : _titleCtrl.text.trim(),
                      _petCtrl.text.trim().isEmpty ? 'Luna' : _petCtrl.text.trim(),
                      _mood,
                      _noteCtrl.text.trim(),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CheckinCard extends StatelessWidget {
  final DailyCheckin item;
  final VoidCallback onToggle;
  const _CheckinCard({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context).t;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: item.completed ? theme.primaryColor : theme.colorScheme.surfaceVariant.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.completed ? Icons.check_rounded : Icons.circle_outlined,
                size: 18,
                color: item.completed ? Colors.white : theme.hintColor,
              ),
            ).animate().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${item.petName} · ${item.timeLabel} · ${t('mood')}: ${item.mood}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                const SizedBox(height: 6),
                Text(item.note, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onToggle,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                item.completed ? Icons.task_alt_rounded : Icons.playlist_add_check_rounded,
                key: ValueKey(item.completed),
                color: item.completed ? theme.primaryColor : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
