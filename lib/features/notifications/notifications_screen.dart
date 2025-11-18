import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/app_notification.dart';
import 'notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController controller;
  const NotificationsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('notifications')),
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text(t('mark_all_read'), style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: StreamBuilder<List<AppNotification>>(
          stream: controller.notificationsStream,
          builder: (context, snapshot) {
            if (controller.isLoading) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Skeleton(height: 82, width: double.infinity),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: 4,
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(child: Text(t('empty_notifications')));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) {
                final n = items[i];
                return _NotificationTile(
                  notification: n,
                  onTap: () {
                    controller.markRead(n);
                    if (n.route != null) {
                      Navigator.pushNamed(context, n.route!);
                    }
                  },
                  timeLabel: _timeAgo(n.createdAt, t),
                  onMarkRead: () => controller.markRead(n),
                ).animate(delay: (80 * i).ms).fadeIn().slide(begin: const Offset(0, 0.08));
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
        ),
      ),
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

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final String timeLabel;
  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onMarkRead,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(notification.icon, color: theme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (!notification.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(AppLocalizations.of(context).t('new'), style: TextStyle(color: theme.primaryColor)),
                        )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notification.body),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(timeLabel, style: theme.textTheme.bodySmall),
                      const Spacer(),
                      if (!notification.isRead)
                        TextButton(
                          onPressed: onMarkRead,
                          child: Text(AppLocalizations.of(context).t('mark_read')),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
