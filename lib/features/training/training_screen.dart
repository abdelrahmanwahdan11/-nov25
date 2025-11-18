import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/training_task.dart';
import 'training_controller.dart';

class TrainingScreen extends StatelessWidget {
  final TrainingController controller;
  const TrainingScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('training')), 
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_graph_rounded),
            onPressed: controller.load,
          )
        ],
      ),
      body: StreamBuilder<List<TrainingTask>>(
        stream: controller.tasksStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Skeleton(height: 130, width: double.infinity),
              ),
            );
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) return Center(child: Text(t('empty_training')));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (_, i) => _TaskCard(task: tasks[i], controller: controller),
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TrainingTask task;
  final TrainingController controller;
  const _TaskCard({required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${task.level} • ${task.petName}'),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => controller.toggleComplete(task),
                icon: Icon(task.completed ? Icons.check_circle : Icons.radio_button_unchecked, color: theme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(task.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: task.progress, minHeight: 10, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: task.steps
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: theme.primaryColor.withOpacity(0.08),
                    ))
                .toList(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => controller.markStepDone(task),
              child: Text(task.completed ? t('done') : t('mark_done')),
            ),
          )
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.1));
  }
}
