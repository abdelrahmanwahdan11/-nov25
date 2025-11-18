import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/timeline_event.dart';
import 'timeline_controller.dart';

class ActivityTimelineScreen extends StatelessWidget {
  final TimelineController controller;
  const ActivityTimelineScreen({super.key, required this.controller});

  String _timeAgo(DateTime date, String Function(String, {List<String>? args}) t) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}${t('minutes_ago')}';
    if (diff.inHours < 24) return '${diff.inHours}${t('hours_ago')}';
    return '${diff.inDays}${t('days_ago')}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('timeline'))),
      body: StreamBuilder<List<TimelineEvent>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          final events = snapshot.data ?? [];
          if (controller.isLoading && events.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Skeleton(height: i.isEven ? 110 : 130, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => controller.load(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (_, i) {
                final event = events[i];
                return _TimelineTile(
                  event: event,
                  timeAgo: _timeAgo(event.dateTime, t),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final TimelineEvent event;
  final String timeAgo;
  const _TimelineTile({required this.event, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(event.accent.replaceFirst('#', '0xff')));
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.18),
            ),
            child: Icon(Icons.timeline_rounded, color: color),
          ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 450.ms),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(event.petName, style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                const SizedBox(height: 4),
                Text(event.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(event.category, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 4),
                        Text(timeAgo, style: Theme.of(context).textTheme.labelMedium),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideX(begin: 0.06, duration: 400.ms);
  }
}
