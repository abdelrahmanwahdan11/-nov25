import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import '../../data/models/pet_reminder.dart';
import '../../data/models/pet_service.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/pet_journal_entry.dart';
import '../care/care_tips_controller.dart';
import '../care/reminder_controller.dart';
import '../adoption/adoption_controller.dart';
import '../home/pet_controller.dart';
import '../services/service_controller.dart';
import '../notifications/notification_controller.dart';
import '../journal/journal_controller.dart';
import '../achievements/achievements_controller.dart';
import '../timeline/timeline_controller.dart';
import '../gallery/gallery_controller.dart';
import '../../data/models/pet_achievement.dart';
import '../../data/models/timeline_event.dart';
import '../../data/models/pet_moment.dart';
import '../care/care_planner_controller.dart';
import '../care/supplies_controller.dart';
import '../care/emergency_controller.dart';
import '../../data/models/care_plan_item.dart';
import '../../data/models/pet_supply.dart';
import '../../data/models/emergency_guide.dart';
import '../community/community_controller.dart';
import '../../data/models/community_event.dart';
import '../insights/insights_controller.dart';
import '../../data/models/insight_metric.dart';
import '../care/meal_plan_controller.dart';
import '../care/vet_visit_controller.dart';
import '../../data/models/meal_plan_item.dart';
import '../../data/models/vet_visit.dart';

class DashboardScreen extends StatelessWidget {
  final PetController petController;
  final ReminderController reminderController;
  final CareTipsController careTipsController;
  final AdoptionController adoptionController;
  final ServiceController serviceController;
  final NotificationController notificationController;
  final JournalController journalController;
  final AchievementsController achievementsController;
  final TimelineController timelineController;
  final GalleryController galleryController;
  final CarePlannerController carePlannerController;
  final SuppliesController suppliesController;
  final EmergencyController emergencyController;
  final MealPlanController mealPlanController;
  final VetVisitController vetVisitController;
  final CommunityController communityController;
  final InsightsController insightsController;
  const DashboardScreen({
    super.key,
    required this.petController,
    required this.reminderController,
    required this.careTipsController,
    required this.adoptionController,
    required this.serviceController,
    required this.notificationController,
    required this.journalController,
    required this.achievementsController,
    required this.timelineController,
    required this.galleryController,
    required this.carePlannerController,
    required this.suppliesController,
    required this.emergencyController,
    required this.mealPlanController,
    required this.vetVisitController,
    required this.communityController,
    required this.insightsController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _greetingHeader(context, t),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickCard(
                  icon: Icons.health_and_safety_outlined,
                  label: t('health_records'),
                  onTap: () => Navigator.pushNamed(context, '/care/health'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.school_rounded,
                  label: t('training'),
                  onTap: () => Navigator.pushNamed(context, '/training'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.support_agent,
                  label: t('help_center'),
                  onTap: () => Navigator.pushNamed(context, '/support/faq'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickCard(
                  icon: Icons.notifications_none_rounded,
                  label: t('notifications'),
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.book_outlined,
                  label: t('journal'),
                  onTap: () => Navigator.pushNamed(context, '/journal'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickCard(
                  icon: Icons.local_hospital_outlined,
                  label: t('vet_visits'),
                  onTap: () => Navigator.pushNamed(context, '/care/vet-visits'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.restaurant_menu_rounded,
                  label: t('meal_plan'),
                  onTap: () => Navigator.pushNamed(context, '/care/meals'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _insightsHighlight(context, t),
          const SizedBox(height: 12),
          _communityStrip(context, t),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickCard(
                  icon: Icons.bolt_rounded,
                  label: t('care_planner'),
                  onTap: () => Navigator.pushNamed(context, '/care/planner'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.inventory_2_outlined,
                  label: t('supplies'),
                  onTap: () => Navigator.pushNamed(context, '/care/supplies'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickCard(
                  icon: Icons.health_and_safety_rounded,
                  label: t('emergency_ready'),
                  onTap: () => Navigator.pushNamed(context, '/care/emergency'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _sectionTitle(t('achievements')),
          _AchievementStrip(controller: achievementsController),
          const SizedBox(height: 14),
          _sectionTitle(t('timeline')),
          _TimelineStrip(controller: timelineController),
          const SizedBox(height: 14),
          _sectionTitle(t('gallery')),
          _GalleryStrip(controller: galleryController),
          const SizedBox(height: 16),
          _sectionTitle(t('notifications')),
          _NotificationStrip(controller: notificationController),
          const SizedBox(height: 16),
          _sectionTitle(t('journal_recent')),
          _JournalStrip(controller: journalController),
          const SizedBox(height: 16),
          _sectionTitle(t('planner_today')),
          _PlannerStrip(controller: carePlannerController),
          const SizedBox(height: 16),
          _sectionTitle(t('supplies_low')),
          _SuppliesStrip(controller: suppliesController),
          const SizedBox(height: 16),
          _sectionTitle(t('emergency_ready')),
          _EmergencyStrip(controller: emergencyController),
          const SizedBox(height: 16),
          _sectionTitle(t('vet_visits')),
          _VetStrip(controller: vetVisitController),
          const SizedBox(height: 16),
          _sectionTitle(t('meal_plan')),
          _MealStrip(controller: mealPlanController),
          const SizedBox(height: 16),
          _sectionTitle(t('upcoming_reminders')),
          _ReminderStrip(controller: reminderController),
          const SizedBox(height: 16),
          _sectionTitle(t('latest_requests')),
          _AdoptionStrip(controller: adoptionController),
          const SizedBox(height: 16),
          _sectionTitle(t('care_highlights')),
          _CareTipsStrip(controller: careTipsController),
          const SizedBox(height: 16),
          _sectionTitle(t('favorites')),
          _FavoritesStrip(controller: petController),
          const SizedBox(height: 16),
          _sectionTitle(t('services')),
          _ServicesStrip(controller: serviceController),
        ],
      ),
    );
  }

  Widget _greetingHeader(BuildContext context, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 12))],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.15),
            ),
            child: const Icon(Icons.dashboard_customize_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('dashboard_greeting'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(t('care_plan')),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/my-pets'),
            child: Text(t('my_pets')),
          )
        ],
      ),
    );
  }

  Widget _insightsHighlight(BuildContext context, String Function(String) t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(t('insights')),
        StreamBuilder<List<InsightMetric>>(
          stream: insightsController.metricsStream,
          builder: (context, snapshot) {
            if (insightsController.isLoading) {
              return const Skeleton(height: 110, width: double.infinity);
            }
            final metrics = snapshot.data ?? [];
            if (metrics.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t('empty_insights')),
              );
            }
            final top = metrics.firstWhere((m) => m.highlight, orElse: () => metrics.first);
            return Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: top.progress),
                          duration: 500.ms,
                          curve: Curves.easeOut,
                          builder: (_, value, __) => CircularProgressIndicator(
                            value: value,
                            strokeWidth: 7,
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.16),
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                          ),
                        ),
                        Text('${(top.progress * 100).round()}%'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(top.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(top.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text(top.trend, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/insights'),
                    icon: const Icon(Icons.chevron_right_rounded),
                  )
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slide(begin: const Offset(0, 0.05));
          },
        )
      ],
    );
  }

  Widget _communityStrip(BuildContext context, String Function(String) t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(t('community_events')),
        const SizedBox(height: 8),
        StreamBuilder<List<CommunityEvent>>(
          stream: communityController.eventsStream,
          builder: (context, snapshot) {
            if (communityController.isLoading) {
              return SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, __) => const Skeleton(height: 140, width: 220),
                ),
              );
            }
            final events = snapshot.data ?? [];
            if (events.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t('empty_events')),
              );
            }
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (_, i) {
                  final e = events[i];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/community'),
                    child: Container(
                      width: 230,
                      margin: EdgeInsets.only(right: i == events.length - 1 ? 0 : 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Icon(Icons.play_circle_fill_outlined, color: Theme.of(context).primaryColor)
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(e.imageUrl, height: 70, width: double.infinity, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 8),
                          Text('${_dateLabel(e.date)} • ${e.isOnline ? t('online') : '${e.distanceKm.toStringAsFixed(1)} km'}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ).animate(delay: (i * 60).ms).fadeIn().scale(begin: const Offset(0.96, 0.96));
                },
              ),
            );
          },
        )
      ],
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day';
  }

  Widget _sectionTitle(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      );
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Icon(Icons.chevron_right_rounded)
          ],
        ),
      ).animate().fadeIn().slide(begin: const Offset(0, 0.08)),
    );
  }
}

class _AchievementStrip extends StatelessWidget {
  final AchievementsController controller;
  const _AchievementStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: StreamBuilder<List<PetAchievement>>(
        stream: controller.achievementsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 130, width: 220),
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const SizedBox.shrink();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final ach = items[i];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(ach.iconUrl, width: 48, height: 48, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ach.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: ach.progress,
                      minHeight: 8,
                      backgroundColor: Theme.of(context).dividerColor.withOpacity(0.2),
                    ).animate().shimmer(duration: 1100.ms),
                    const SizedBox(height: 6),
                    Text('${(ach.progress * 100).round()}%', style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ).animate().fadeIn(duration: 320.ms).slideX(begin: 0.05);
            },
          );
        },
      ),
    );
  }
}

class _TimelineStrip extends StatelessWidget {
  final TimelineController controller;
  const _TimelineStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: StreamBuilder<List<TimelineEvent>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 120, width: 200),
              ),
            );
          }
          final events = snapshot.data ?? [];
          if (events.isEmpty) return const SizedBox.shrink();
          final visible = events.take(4).toList();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemCount: visible.length,
            itemBuilder: (_, i) {
              final e = visible[i];
              final color = Color(int.parse(e.accent.replaceFirst('#', '0xff')));
              return Container(
                width: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: color.withOpacity(0.16), shape: BoxShape.circle),
                          child: Icon(Icons.timeline_rounded, size: 18, color: color),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(e.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text('${e.petName} · ${e.category}', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ).animate().fadeIn(duration: 320.ms).scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));
            },
          );
        },
      ),
    );
  }
}

class _GalleryStrip extends StatelessWidget {
  final GalleryController controller;
  const _GalleryStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder<List<PetMoment>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 110, width: 160),
              ),
            );
          }
          final moments = snapshot.data ?? [];
          if (moments.isEmpty) return const SizedBox.shrink();
          final visible = moments.take(5).toList();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visible.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final moment = visible[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(moment.imageUrl, width: 160, height: 120, fit: BoxFit.cover),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(moment.petName, style: const TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 280.ms).slideX(begin: 0.04);
            },
          );
        },
      ),
    );
  }
}

class _NotificationStrip extends StatelessWidget {
  final NotificationController controller;
  const _NotificationStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<AppNotification>>(
        stream: controller.notificationsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 140, width: 220),
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text(t('empty_notifications')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final n = items[i];
              final timeLabel = _timeAgo(n.createdAt, t);
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(n.icon, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                        if (!n.isRead)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(t('new'), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
                          )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Row(
                      children: [
                        Text(timeLabel, style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: () {
                            controller.markRead(n);
                            if (n.route != null) Navigator.pushNamed(context, n.route!);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn();
            },
          );
        },
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

class _JournalStrip extends StatelessWidget {
  final JournalController controller;
  const _JournalStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 160,
      child: StreamBuilder<List<PetJournalEntry>>(
        stream: controller.entriesStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 150, width: 220),
              ),
            );
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(child: Text(t('empty_journal')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final entry = entries[i];
              return Container(
                width: 230,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(entry.mood, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(entry.petName, style: TextStyle(color: Theme.of(context).primaryColor)),
                    const SizedBox(height: 6),
                    Expanded(child: Text(entry.note, maxLines: 3, overflow: TextOverflow.ellipsis)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(_timeAgo(entry.createdAt, t), style: Theme.of(context).textTheme.bodySmall),
                    )
                  ],
                ),
              ).animate().fadeIn();
            },
          );
        },
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

class _PlannerStrip extends StatelessWidget {
  final CarePlannerController controller;
  const _PlannerStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<CarePlanItem>>(
        stream: controller.itemsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 140, width: 220),
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) return Center(child: Text(t('care_planner_subtitle')));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Container(
                width: 230,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(item.category),
                        ),
                        const Spacer(),
                        Text(item.scheduledAt, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${item.petName} · ${item.durationMinutes}m'),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(item.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: item.isDone ? Colors.green : Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.note, maxLines: 2, overflow: TextOverflow.ellipsis)),
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn().slide(begin: const Offset(0, 0.08));
            },
          );
        },
      ),
    );
  }
}

class _SuppliesStrip extends StatelessWidget {
  final SuppliesController controller;
  const _SuppliesStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<PetSupply>>(
        stream: controller.suppliesStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 140, width: 200),
              ),
            );
          }
          final items = (snapshot.data ?? []).where((s) => s.lowStock).toList();
          if (items.isEmpty) return Center(child: Text(t('all_stock_ok')));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final s = items[i];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.category, style: Theme.of(context).textTheme.labelSmall),
                    Text(s.name, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 6),
                        Text('${s.quantity} ${s.unit}'),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration:
                              BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                          child: Text(t('low_stock'), style: TextStyle(color: Colors.red.shade600)),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right),
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn().slide(begin: const Offset(0, 0.08));
            },
          );
        },
      ),
    );
  }
}

class _EmergencyStrip extends StatelessWidget {
  final EmergencyController controller;
  const _EmergencyStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<EmergencyGuide>>(
        stream: controller.guidesStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 140, width: 220),
              ),
            );
          }
          final guides = snapshot.data ?? [];
          if (guides.isEmpty) return Center(child: Text(t('emergency_description')));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: guides.length,
            itemBuilder: (_, i) {
              final g = guides[i];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.health_and_safety_rounded, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(g.title, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(g.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text(t('hotline_label', namedArgs: {'number': g.hotline})),
                  ],
                ),
              ).animate().fadeIn().slide(begin: const Offset(0, 0.08));
            },
          );
        },
      ),
    );
  }
}

class _VetStrip extends StatelessWidget {
  final VetVisitController controller;
  const _VetStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 150,
      child: StreamBuilder<List<VetVisit>>(
        stream: controller.visitsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 140, width: 220),
              ),
            );
          }
          final visits = snapshot.data ?? [];
          if (visits.isEmpty) return Center(child: Text(t('upcoming_visit')));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: visits.length,
            itemBuilder: (_, i) {
              final v = visits[i];
              final statusColor = v.status == 'completed'
                  ? Colors.green
                  : v.status == 'urgent'
                      ? Colors.redAccent
                      : Theme.of(context).primaryColor;
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage(v.imageUrl)),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${v.petName} · ${TimeOfDay.fromDateTime(v.dateTime).format(context)}')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(v.clinicName, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(v.reason, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            v.status == 'completed'
                                ? t('completed_visit')
                                : v.status == 'urgent'
                                    ? t('urgent')
                                    : t('upcoming_visit'),
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.local_hospital_outlined, color: statusColor),
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn().slide(begin: const Offset(0, 0.08));
            },
          );
        },
      ),
    );
  }
}

class _MealStrip extends StatelessWidget {
  final MealPlanController controller;
  const _MealStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return SizedBox(
      height: 130,
      child: StreamBuilder<List<MealPlanItem>>(
        stream: controller.itemsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 120, width: 190),
              ),
            );
          }
          final meals = snapshot.data ?? [];
          if (meals.isEmpty) return Center(child: Text(t('meal_plan')));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: meals.length,
            itemBuilder: (_, i) {
              final m = meals[i];
              return Container(
                width: 190,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu_rounded, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(m.time.format(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(m.meal, maxLines: 2, style: Theme.of(context).textTheme.titleMedium),
                    Text('${m.petName} · ${t('calories')}: ${m.calories}', style: Theme.of(context).textTheme.bodySmall),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (m.isDone ? Colors.green : Theme.of(context).primaryColor).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            m.isDone ? t('mark_done') : t('mark_eaten'),
                            style: TextStyle(
                              color: m.isDone ? Colors.green : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(m.isDone ? Icons.check_circle : Icons.schedule_rounded,
                            color: m.isDone ? Colors.green : Theme.of(context).primaryColor)
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn().slide(begin: const Offset(0, 0.06));
            },
          );
        },
      ),
    );
  }
}

class _ReminderStrip extends StatelessWidget {
  final ReminderController controller;
  const _ReminderStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder<List<PetReminder>>(
        stream: controller.remindersStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 110, width: 200),
              ),
            );
          }
          final reminders = snapshot.data ?? [];
          if (reminders.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_reminders')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final r = reminders[i];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(r.timeLabel),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => controller.toggleDone(r),
                        child: Text(AppLocalizations.of(context).t('mark_done')),
                      ),
                    )
                  ],
                ),
              ).animate().fadeIn();
            },
          );
        },
      ),
    );
  }
}

class _AdoptionStrip extends StatelessWidget {
  final AdoptionController controller;
  const _AdoptionStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: controller.requestsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 100, width: 220),
              ),
            );
          }
          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_requests')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: requests.length,
            itemBuilder: (_, i) {
              final r = requests[i];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.petName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${AppLocalizations.of(context).t('submitted_on')}: ${r.submittedAt.toLocal().toString().split(' ').first}'),
                    const Spacer(),
                    Text(r.status.toUpperCase(), style: TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              ).animate().slide(begin: const Offset(0.1, 0));
            },
          );
        },
      ),
    );
  }
}

class _CareTipsStrip extends StatelessWidget {
  final CareTipsController controller;
  const _CareTipsStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: controller.tipsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 110, width: 180),
              ),
            );
          }
          final tips = snapshot.data ?? [];
          if (tips.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_tips')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tips.length,
            itemBuilder: (_, i) {
              final tip = tips[i];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Expanded(child: Text(tip.description, maxLines: 3, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms);
            },
          );
        },
      ),
    );
  }
}

class _FavoritesStrip extends StatelessWidget {
  final PetController controller;
  const _FavoritesStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: StreamBuilder<List<Pet>>(
        stream: controller.favoritesStream,
        builder: (context, snapshot) {
          final pets = snapshot.data ?? [];
          if (pets.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_favorites')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            itemBuilder: (_, i) {
              final pet = pets[i];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Image.network(pet.imageUrl, fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pet.name),
                    )
                  ],
                ),
              ).animate().scale(begin: const Offset(0.96, 0.96));
            },
          );
        },
      ),
    );
  }
}

class _ServicesStrip extends StatelessWidget {
  final ServiceController controller;
  const _ServicesStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: StreamBuilder<List<PetService>>(
        stream: controller.servicesStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Skeleton(height: 120, width: 200),
              ),
            );
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('pet_care_nearby')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (_, i) {
              final s = services[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/services/details', arguments: s),
                child: Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(s.imageUrl), radius: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${s.distanceKm} km · ${s.rating}★'),
                          ],
                        ),
                      )
                    ],
                  ),
                ).animate().fadeIn(),
              );
            },
          );
        },
      ),
    );
  }
}
