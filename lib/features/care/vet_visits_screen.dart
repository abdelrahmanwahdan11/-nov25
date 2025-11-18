import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/vet_visit.dart';
import 'vet_visit_controller.dart';

class VetVisitsScreen extends StatefulWidget {
  final VetVisitController controller;
  const VetVisitsScreen({super.key, required this.controller});

  @override
  State<VetVisitsScreen> createState() => _VetVisitsScreenState();
}

class _VetVisitsScreenState extends State<VetVisitsScreen> {
  final _petCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _clinicCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    _petCtrl.dispose();
    _reasonCtrl.dispose();
    _clinicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('vet_visits')),
        actions: [
          IconButton(onPressed: widget.controller.load, icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add_alert_rounded),
        label: Text(t('add_visit')),
      ),
      body: StreamBuilder<List<VetVisit>>(
        stream: widget.controller.visitsStream,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          if (widget.controller.isLoading && list.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Skeleton(height: 120, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final visit = list[index];
                return _VisitCard(
                  visit: visit,
                  onMarkDone: () => widget.controller.markCompleted(visit),
                  onMarkUrgent: () => widget.controller.markUrgent(visit),
                ).animate().fadeIn(duration: 350.ms, delay: (50 * index).ms).slideY(begin: 0.08);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAdd() async {
    final t = AppLocalizations.of(context).t;
    _petCtrl.clear();
    _reasonCtrl.clear();
    _clinicCtrl.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(t('add_visit'), style: Theme.of(context).textTheme.titleMedium)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
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
              TextField(
                controller: _clinicCtrl,
                decoration: InputDecoration(
                  hintText: t('clinic'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reasonCtrl,
                decoration: InputDecoration(
                  hintText: t('reason'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (_petCtrl.text.trim().isEmpty) return;
                  widget.controller.addVisit(
                    VetVisit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      petName: _petCtrl.text.trim(),
                      clinicName: _clinicCtrl.text.trim().isNotEmpty ? _clinicCtrl.text.trim() : 'Local vet',
                      dateTime: DateTime.now().add(const Duration(days: 2)),
                      doctor: 'Team vet',
                      reason: _reasonCtrl.text.trim().isEmpty ? t('upcoming_visit') : _reasonCtrl.text.trim(),
                      status: 'upcoming',
                      note: t('added_quickly'),
                      imageUrl: 'https://images.unsplash.com/photo-1501820488136-72669149e0d4',
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save_rounded),
                label: Text(t('save')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VisitCard extends StatelessWidget {
  final VetVisit visit;
  final VoidCallback onMarkDone;
  final VoidCallback onMarkUrgent;
  const _VisitCard({required this.visit, required this.onMarkDone, required this.onMarkUrgent});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final statusColor = visit.status == 'completed'
        ? Colors.green
        : visit.status == 'urgent'
            ? Colors.redAccent
            : Theme.of(context).colorScheme.primary;
    final time = TimeOfDay.fromDateTime(visit.dateTime);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(visit.imageUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${visit.petName} · ${visit.clinicName}', style: Theme.of(context).textTheme.titleMedium),
                    Text('${time.format(context)} • ${visit.doctor}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                child: Text(
                  visit.status == 'completed'
                      ? t('completed_visit')
                      : visit.status == 'urgent'
                          ? t('urgent')
                          : t('upcoming_visit'),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(visit.reason, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(visit.note, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              if (visit.status != 'completed')
                ElevatedButton.icon(
                  onPressed: onMarkDone,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(t('mark_arrived')),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                ),
              const SizedBox(width: 8),
              if (visit.status != 'urgent')
                OutlinedButton.icon(
                  onPressed: onMarkUrgent,
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: Text(t('urgent')),
                  style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                )
            ],
          )
        ],
      ),
    );
  }
}
