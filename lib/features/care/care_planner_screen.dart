import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/care_plan_item.dart';
import 'care_planner_controller.dart';

class CarePlannerScreen extends StatefulWidget {
  final CarePlannerController controller;
  const CarePlannerScreen({super.key, required this.controller});

  @override
  State<CarePlannerScreen> createState() => _CarePlannerScreenState();
}

class _CarePlannerScreenState extends State<CarePlannerScreen> {
  final _titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('care_planner')),
        actions: [
          IconButton(
            onPressed: widget.controller.load,
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openQuickAdd,
        label: Text(t('add_quick_task')),
        icon: const Icon(Icons.add_task_rounded),
      ),
      body: StreamBuilder<List<CarePlanItem>>(
        stream: widget.controller.itemsStream,
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(t('care_planner_subtitle'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...list.map((item) => _CareItemCard(
                      item: item,
                      onToggle: () => widget.controller.toggleDone(item),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openQuickAdd() async {
    final t = AppLocalizations.of(context).t;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t('quick_add'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: t('what_to_plan'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  if (_titleCtrl.text.trim().isEmpty) return;
                  final now = TimeOfDay.now();
                  widget.controller.addQuickItem(
                    CarePlanItem(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      petName: 'Luna',
                      title: _titleCtrl.text.trim(),
                      category: 'custom',
                      scheduledAt: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                      durationMinutes: 10,
                      intensity: 'Gentle',
                      note: t('added_quickly'),
                      isDone: false,
                    ),
                  );
                  _titleCtrl.clear();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.bolt_rounded),
                label: Text(t('save_plan')),
              )
            ],
          ),
        );
      },
    );
  }
}

class _CareItemCard extends StatelessWidget {
  final CarePlanItem item;
  final VoidCallback onToggle;
  const _CareItemCard({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final t = AppLocalizations.of(context).t;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.scheduledAt, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.16), borderRadius: BorderRadius.circular(16)),
                child: Text(item.category, style: TextStyle(color: color)),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('${item.petName} • ${item.durationMinutes}m • ${item.intensity}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text(item.note, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onToggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.isDone ? color.withOpacity(0.2) : color,
                        foregroundColor: item.isDone ? color : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(item.isDone ? t('mark_undone') : t('mark_done')),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).moveY(begin: 8, end: 0, duration: 400.ms);
  }
}
