import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/meal_plan_item.dart';
import 'meal_plan_controller.dart';

class MealPlanScreen extends StatefulWidget {
  final MealPlanController controller;
  const MealPlanScreen({super.key, required this.controller});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final _mealCtrl = TextEditingController();
  final _petCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    _mealCtrl.dispose();
    _petCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('meal_plan')),
        actions: [IconButton(onPressed: widget.controller.load, icon: const Icon(Icons.refresh_rounded))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.restaurant_menu_rounded),
        label: Text(t('add_meal')),
      ),
      body: StreamBuilder<List<MealPlanItem>>(
        stream: widget.controller.itemsStream,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          if (widget.controller.isLoading && list.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: Skeleton(height: 96, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return _MealTile(
                  item: item,
                  onToggle: () => widget.controller.toggleDone(item),
                ).animate().fadeIn(duration: 350.ms, delay: (40 * index).ms).slideY(begin: 0.08);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAdd() async {
    final t = AppLocalizations.of(context).t;
    _mealCtrl.clear();
    _petCtrl.clear();
    _noteCtrl.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
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
                  Expanded(child: Text(t('add_meal'), style: Theme.of(context).textTheme.titleMedium)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _mealCtrl,
                decoration: InputDecoration(
                  hintText: t('meal_plan'),
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
              TextField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  hintText: t('notes_hint'),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (_mealCtrl.text.trim().isEmpty) return;
                  widget.controller.addItem(
                    MealPlanItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      petName: _petCtrl.text.trim().isEmpty ? t('unknown_pet') : _petCtrl.text.trim(),
                      meal: _mealCtrl.text.trim(),
                      time: TimeOfDay.now(),
                      calories: 180,
                      isDone: false,
                      note: _noteCtrl.text.trim().isEmpty ? t('added_quickly') : _noteCtrl.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save_alt_rounded),
                label: Text(t('save')),
              )
            ],
          ),
        );
      },
    );
  }
}

class _MealTile extends StatelessWidget {
  final MealPlanItem item;
  final VoidCallback onToggle;
  const _MealTile({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isDone ? Colors.green.withOpacity(0.14) : Theme.of(context).colorScheme.primary.withOpacity(0.12),
            ),
            child: Icon(item.isDone ? Icons.check_rounded : Icons.schedule_rounded,
                color: item.isDone ? Colors.green : Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.meal, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${item.petName} · ${item.time.format(context)}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text('${t('calories')}: ${item.calories}', style: Theme.of(context).textTheme.labelMedium),
                if (item.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(item.note, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
                  )
              ],
            ),
          ),
          Switch(
            value: item.isDone,
            onChanged: (_) => onToggle(),
            activeColor: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
