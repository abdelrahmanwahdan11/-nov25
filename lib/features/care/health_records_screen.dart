import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/health_record.dart';
import 'health_controller.dart';

class HealthRecordsScreen extends StatelessWidget {
  final HealthController controller;
  const HealthRecordsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('health_records')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            onPressed: () {
              controller.addQuickRecord(HealthRecord(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                petName: 'Luna',
                type: 'Custom check',
                date: DateTime.now().add(const Duration(days: 2)),
                location: 'Home visit',
                note: t('no_note'),
              ));
            },
          )
        ],
      ),
      body: StreamBuilder<List<HealthRecord>>(
        stream: controller.recordsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Skeleton(height: 110, width: double.infinity),
              ),
            );
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return Center(child: Text(t('empty_health')));
          }
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (_, i) => _RecordTile(record: records[i], controller: controller),
            ),
          );
        },
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final HealthRecord record;
  final HealthController controller;
  const _RecordTile({required this.record, required this.controller});

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.primaryColor.withOpacity(0.18),
            child: Icon(Icons.vaccines_outlined, color: theme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${record.petName} • ${record.formattedDate}'),
                const SizedBox(height: 4),
                Text(record.location, style: theme.textTheme.bodySmall),
                if (record.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(record.note, style: theme.textTheme.bodySmall),
                ]
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: record.badgeColor(theme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(record.completed ? t('done') : t('upcoming')),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => controller.toggleComplete(record),
                icon: Icon(record.completed ? Icons.check_circle : Icons.radio_button_unchecked),
              )
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
  }
}
