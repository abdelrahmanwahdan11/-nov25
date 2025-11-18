import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import 'pet_controller.dart';
import '../adoption/adoption_controller.dart';
import '../care/reminder_controller.dart';
import '../notifications/notification_controller.dart';
import '../journal/journal_controller.dart';
import '../../data/models/pet_journal_entry.dart';
import '../../data/models/app_notification.dart';
import '../achievements/achievements_controller.dart';
import '../timeline/timeline_controller.dart';
import '../gallery/gallery_controller.dart';
import '../../data/models/timeline_event.dart';
import '../../data/models/pet_moment.dart';
import '../../data/models/pet_achievement.dart';
import '../care/care_planner_controller.dart';
import '../care/supplies_controller.dart';
import '../care/emergency_controller.dart';
import '../../data/models/care_plan_item.dart';
import '../../data/models/pet_supply.dart';
import '../../data/models/emergency_guide.dart';
import '../care/meal_plan_controller.dart';
import '../care/vet_visit_controller.dart';
import '../../data/models/meal_plan_item.dart';
import '../../data/models/vet_visit.dart';
import '../community/community_controller.dart';
import '../../data/models/community_event.dart';
import '../insights/insights_controller.dart';
import '../../data/models/insight_metric.dart';

class HomeDiscoverScreen extends StatefulWidget {
  final PetController petController;
  final AdoptionController adoptionController;
  final ReminderController reminderController;
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
  const HomeDiscoverScreen({
    super.key,
    required this.petController,
    required this.adoptionController,
    required this.reminderController,
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
  State<HomeDiscoverScreen> createState() => _HomeDiscoverScreenState();
}

class _HomeDiscoverScreenState extends State<HomeDiscoverScreen> {
  final _pageController = PageController(viewportFraction: 0.82);
  PetType? selectedType;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: widget.petController.refreshPets,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('discover_title'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(t('discover_subtitle'), style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none_rounded),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: StreamBuilder<List<AppNotification>>(
                                stream: widget.notificationController.notificationsStream,
                                builder: (context, snapshot) {
                                  final hasUnread = (snapshot.data ?? []).any((n) => !n.isRead);
                                  if (!hasUnread) return const SizedBox.shrink();
                                  return Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/pet/compare'),
                        icon: const Icon(Icons.filter_alt_outlined),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(t('all')),
                        selected: selectedType == null,
                        onSelected: (_) {
                          setState(() => selectedType = null);
                          widget.petController.refreshPets();
                        },
                      ),
                    ),
                    ...PetType.values
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                selectedColor: Theme.of(context).primaryColor,
                                label: Text(e.name),
                                selected: selectedType == e,
                                onSelected: (_) {
                                  setState(() => selectedType = e);
                                  widget.petController.filterByType(e);
                                },
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _insightsPeek(context, t),
              const SizedBox(height: 12),
              _communityPeek(context, t),
              const SizedBox(height: 16),
              _plannerPeek(context, t),
              const SizedBox(height: 12),
              _mealPlanPeek(context, t),
              const SizedBox(height: 12),
              _suppliesPeek(context, t),
              const SizedBox(height: 12),
              _emergencyPeek(context, t),
              const SizedBox(height: 12),
              _vetPeek(context, t),
              const SizedBox(height: 16),
              _journalPeek(context, t),
              const SizedBox(height: 16),
              _achievementsPeek(context, t),
              const SizedBox(height: 16),
              _timelineStrip(context, t),
              const SizedBox(height: 16),
              _galleryStrip(context, t),
              const SizedBox(height: 16),
              SizedBox(
                height: 380,
                child: StreamBuilder<List<Pet>>(
                  stream: widget.petController.petsStream,
                  builder: (context, snapshot) {
                    if (widget.petController.isLoading) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Skeleton(height: 360, width: 280),
                        ),
                      );
                    }
                    final pets = snapshot.data ?? [];
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: pets.length,
                      itemBuilder: (_, i) {
                        final pet = pets[i];
                        return _PetCard(pet: pet, onTap: () => _openDetails(pet)).animate().scale(begin: const Offset(0.95, 0.95));
                      },
                      onPageChanged: (i) {
                        if (i >= pets.length - 1) {
                          widget.petController.loadMorePets();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                icon: const Icon(Icons.pets),
                label: Text(t('see_more')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _insightsPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<InsightMetric>>(
      stream: widget.insightsController.metricsStream,
      builder: (context, snapshot) {
        if (widget.insightsController.isLoading) {
          return const Skeleton(height: 100, width: double.infinity);
        }
        final metrics = snapshot.data ?? [];
        final m = metrics.isNotEmpty ? metrics.first : null;
        return _PeekCard(
          title: t('insights'),
          subtitle: m != null ? '${(m.progress * 100).round()}% · ${m.trend}' : t('empty_insights'),
          icon: Icons.donut_small_outlined,
          onTap: () => Navigator.pushNamed(context, '/insights'),
        );
      },
    );
  }

  Widget _communityPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<CommunityEvent>>(
      stream: widget.communityController.eventsStream,
      builder: (context, snapshot) {
        if (widget.communityController.isLoading) {
          return const Skeleton(height: 100, width: double.infinity);
        }
        final events = snapshot.data ?? [];
        final e = events.isNotEmpty ? events.first : null;
        return _PeekCard(
          title: t('community_events'),
          subtitle: e != null
              ? '${e.title} · ${e.isOnline ? t('online') : '${e.distanceKm.toStringAsFixed(1)} km'}'
              : t('empty_events'),
          icon: Icons.celebration_outlined,
          onTap: () => Navigator.pushNamed(context, '/community'),
        );
      },
    );
  }

  Widget _plannerPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<CarePlanItem>>(
      stream: widget.carePlannerController.itemsStream,
      builder: (context, snapshot) {
        if (widget.carePlannerController.isLoading) {
          return const Skeleton(height: 110, width: double.infinity);
        }
        final items = snapshot.data ?? [];
        final top = items.isNotEmpty ? items.first : null;
        return _PeekCard(
          title: t('planner_today'),
          subtitle: top != null ? '${top.title} · ${top.scheduledAt}' : t('care_planner_subtitle'),
          icon: Icons.bolt_rounded,
          onTap: () => Navigator.pushNamed(context, '/care/planner'),
        );
      },
    );
  }

  Widget _mealPlanPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<MealPlanItem>>(
      stream: widget.mealPlanController.itemsStream,
      builder: (context, snapshot) {
        if (widget.mealPlanController.isLoading) {
          return const Skeleton(height: 100, width: double.infinity);
        }
        final meals = snapshot.data ?? [];
        final first = meals.isNotEmpty ? meals.first : null;
        return _PeekCard(
          title: t('today_meals'),
          subtitle:
              first != null ? '${first.petName} · ${first.time.format(context)}' : t('meal_plan'),
          icon: Icons.restaurant_menu_rounded,
          onTap: () => Navigator.pushNamed(context, '/care/meals'),
        );
      },
    );
  }

  Widget _suppliesPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<PetSupply>>(
      stream: widget.suppliesController.suppliesStream,
      builder: (context, snapshot) {
        if (widget.suppliesController.isLoading) {
          return const Skeleton(height: 100, width: double.infinity);
        }
        final lows = (snapshot.data ?? []).where((s) => s.lowStock).toList();
        final label = lows.isNotEmpty ? '${lows.first.name} (${lows.first.quantity} ${lows.first.unit})' : t('all_stock_ok');
        return _PeekCard(
          title: t('supplies_low'),
          subtitle: label,
          icon: Icons.inventory_2_outlined,
          onTap: () => Navigator.pushNamed(context, '/care/supplies'),
        );
      },
    );
  }

  Widget _emergencyPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder(
      stream: widget.emergencyController.guidesStream,
      builder: (context, snapshot) {
        if (widget.emergencyController.isLoading) {
          return const Skeleton(height: 110, width: double.infinity);
        }
        final guides = snapshot.data as List<EmergencyGuide>? ?? [];
        final text = guides.isNotEmpty ? guides.first.title : t('emergency_description');
        return _PeekCard(
          title: t('emergency_ready'),
          subtitle: text,
          icon: Icons.health_and_safety_rounded,
          onTap: () => Navigator.pushNamed(context, '/care/emergency'),
        );
      },
    );
  }

  Widget _vetPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<VetVisit>>(
      stream: widget.vetVisitController.visitsStream,
      builder: (context, snapshot) {
        if (widget.vetVisitController.isLoading) {
          return const Skeleton(height: 100, width: double.infinity);
        }
        final visits = (snapshot.data ?? []).where((v) => v.status != 'completed').toList();
        final next = visits.isNotEmpty ? visits.first : null;
        final time = next != null ? TimeOfDay.fromDateTime(next.dateTime).format(context) : '';
        return _PeekCard(
          title: t('vet_visits'),
          subtitle: next != null ? '${next.petName} · $time' : t('upcoming_visit'),
          icon: Icons.local_hospital_outlined,
          onTap: () => Navigator.pushNamed(context, '/care/vet-visits'),
        );
      },
    );
  }

  Widget _journalPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<PetJournalEntry>>(
      stream: widget.journalController.entriesStream,
      builder: (context, snapshot) {
        if (widget.journalController.isLoading) {
          return const Skeleton(height: 120, width: double.infinity);
        }
        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return _JournalCardPlaceholder(t: t, onTap: () => Navigator.pushNamed(context, '/journal'));
        }
        final latest = entries.first;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/journal'),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 10))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.book_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('journal'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${latest.petName} · ${latest.title}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(latest.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded)
              ],
            ),
          ).animate().fadeIn().slide(begin: const Offset(0, 0.06)),
        );
      },
    );
  }

  Widget _achievementsPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<PetAchievement>>(
      stream: widget.achievementsController.achievementsStream,
      builder: (context, snapshot) {
        final achievements = snapshot.data ?? [];
        if (widget.achievementsController.isLoading && achievements.isEmpty) {
          return const Skeleton(height: 110, width: double.infinity);
        }
        if (achievements.isEmpty) {
          return _JournalCardPlaceholder(t: t, onTap: () => Navigator.pushNamed(context, '/achievements'));
        }
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/achievements'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.emoji_events_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('achievements'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(t('achievements_hint'), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded)
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.05),
        );
      },
    );
  }

  Widget _timelineStrip(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<TimelineEvent>>(
      stream: widget.timelineController.stream,
      builder: (context, snapshot) {
        final events = snapshot.data ?? [];
        if (widget.timelineController.isLoading && events.isEmpty) {
          return const Skeleton(height: 110, width: double.infinity);
        }
        if (events.isEmpty) return const SizedBox.shrink();
        final display = events.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t('timeline'), style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/timeline'),
                  child: Text(t('view_all')),
                )
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: display.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final event = display[i];
                  final color = Color(int.parse(event.accent.replaceFirst('#', '0xff')));
                  return Container(
                    width: 220,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: color.withOpacity(0.18), shape: BoxShape.circle),
                              child: Icon(Icons.timeline_rounded, color: color),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('${event.petName} · ${event.category}', style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(height: 6),
                        Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ).animate().slideX(begin: 0.08, duration: 350.ms).fadeIn(duration: 350.ms);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _galleryStrip(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<PetMoment>>(
      stream: widget.galleryController.stream,
      builder: (context, snapshot) {
        final moments = snapshot.data ?? [];
        if (widget.galleryController.isLoading && moments.isEmpty) {
          return const Skeleton(height: 120, width: double.infinity);
        }
        if (moments.isEmpty) return const SizedBox.shrink();
        final visible = moments.take(6).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(t('gallery'), style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/gallery'),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                )
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final moment = visible[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(moment.imageUrl, width: 150, height: 120, fit: BoxFit.cover),
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
                    ).animate().scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1), duration: 320.ms).fadeIn(duration: 320.ms),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: visible.length,
              ),
            )
          ],
        );
      },
    );
  }

  void _openDetails(Pet pet) {
    Navigator.pushNamed(
      context,
      '/pet/details',
      arguments: PetDetailsArgs(
        pet,
        adoptionController: widget.adoptionController,
        reminderController: widget.reminderController,
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;
  const _PetCard({required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: Hero(
                  tag: pet.id,
                  child: Image.network(pet.imageUrl, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('${pet.breed} · ${pet.ageYears}y · ${pet.weightKg}kg'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PeekCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _PeekCard({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded)
          ],
        ),
      ),
    );
  }
}

class _JournalCardPlaceholder extends StatelessWidget {
  final String Function(String) t;
  final VoidCallback onTap;
  const _JournalCardPlaceholder({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.edit_note, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(t('empty_journal'))),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class PetDetailsArgs {
  final Pet pet;
  final AdoptionController? adoptionController;
  final ReminderController? reminderController;
  PetDetailsArgs(this.pet, {this.adoptionController, this.reminderController});
}
