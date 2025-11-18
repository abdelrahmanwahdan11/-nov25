import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_reminder.dart';
import 'reminder_controller.dart';

class RemindersScreen extends StatefulWidget {
  final ReminderController controller;
  const RemindersScreen({super.key, required this.controller});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('reminders'))),
      body: RefreshIndicator(
        onRefresh: widget.controller.load,
        child: StreamBuilder<List<PetReminder>>(
          stream: widget.controller.remindersStream,
          builder: (context, snapshot) {
            if (widget.controller.isLoading) {
              return ListView.builder(
                itemCount: 4,
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Skeleton(height: 90, width: double.infinity),
                ),
              );
            }
            final reminders = snapshot.data ?? [];
            if (reminders.isEmpty) {
              return Center(child: Text(t('empty_reminders')));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              itemBuilder: (_, i) {
                final reminder = reminders[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.16),
                      child: Icon(Icons.alarm, color: Theme.of(context).primaryColor),
                    ),
                    title: Text(reminder.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${reminder.type} · ${reminder.timeLabel}'),
                    trailing: Checkbox(
                      value: reminder.isDone,
                      onChanged: (_) => setState(() => widget.controller.toggleDone(reminder)),
                      shape: const StadiumBorder(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
