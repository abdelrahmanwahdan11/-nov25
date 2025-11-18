import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/community_event.dart';
import 'community_controller.dart';

class CommunityEventsScreen extends StatelessWidget {
  final CommunityController controller;
  const CommunityEventsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('community_events')),
        actions: [
          IconButton(
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: StreamBuilder<List<CommunityEvent>>(
          stream: controller.eventsStream,
          builder: (context, snapshot) {
            if (controller.isLoading) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Skeleton(height: 180, width: double.infinity),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: 4,
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(child: Text(t('empty_events')));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) {
                final e = items[i];
                return _EventCard(
                  event: e,
                  onTap: () {},
                  onSave: () => controller.toggleSaved(e),
                  t: t,
                ).animate(delay: (60 * i).ms).fadeIn().slide(begin: const Offset(0, 0.06));
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CommunityEvent event;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final String Function(String) t;
  const _EventCard({required this.event, required this.onTap, required this.onSave, required this.t});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: Stack(
                children: [
                  Image.network(event.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(event.isOnline ? Icons.wifi_rounded : Icons.place_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(event.isOnline ? t('online') : '${event.distanceKm.toStringAsFixed(1)} km',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('${_dateLabel(event.date)} • ${event.location}', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onSave,
                        icon: Icon(event.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: event.saved ? theme.primaryColor : theme.iconTheme.color),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(tag, style: TextStyle(color: theme.primaryColor)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.play_circle_fill_outlined),
                        label: Text(t('event_join')),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                      const SizedBox(width: 12),
                      Text(t('event_spots'), style: theme.textTheme.bodySmall),
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

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day';
  }
}
