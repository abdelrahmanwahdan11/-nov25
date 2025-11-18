import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/pet.dart';
import '../../data/models/pet_service.dart';
import '../home/pet_controller.dart';
import '../services/service_controller.dart';
import '../settings/settings_screen.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/localization/locale_controller.dart';
import '../care/care_tips_controller.dart';
import '../care/care_tips_screen.dart';
import '../care/reminder_controller.dart';
import '../care/reminders_screen.dart';
import '../home/favorites_screen.dart';
import '../adoption/adoption_controller.dart';
import '../adoption/adoption_requests_screen.dart';
import '../home/dashboard_screen.dart';
import 'my_pets_screen.dart';
import '../notifications/notification_controller.dart';
import '../notifications/notifications_screen.dart';
import '../journal/journal_controller.dart';
import '../journal/pet_journal_screen.dart';
import '../achievements/achievements_controller.dart';
import '../achievements/achievements_screen.dart';
import '../timeline/timeline_controller.dart';
import '../timeline/activity_timeline_screen.dart';
import '../gallery/gallery_controller.dart';
import '../gallery/pet_gallery_screen.dart';
import '../care/care_planner_controller.dart';
import '../care/care_planner_screen.dart';
import '../care/supplies_controller.dart';
import '../care/supplies_screen.dart';
import '../care/emergency_controller.dart';
import '../care/emergency_screen.dart';
import '../care/meal_plan_controller.dart';
import '../care/meal_plan_screen.dart';
import '../care/vet_visit_controller.dart';
import '../care/vet_visits_screen.dart';
import '../care/daily_checkin_controller.dart';
import '../care/daily_checkin_screen.dart';
import '../community/community_controller.dart';
import '../community/community_events_screen.dart';
import '../insights/insights_controller.dart';
import '../insights/insights_screen.dart';

class ProfileScreen extends StatelessWidget {
  final PetController petController;
  final ServiceController serviceController;
  final ThemeController themeController;
  final LocaleController localeController;
  final CareTipsController careTipsController;
  final ReminderController reminderController;
  final AdoptionController adoptionController;
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
  final DailyCheckinController dailyCheckinController;
  const ProfileScreen({
    super.key,
    required this.petController,
    required this.serviceController,
    required this.themeController,
    required this.localeController,
    required this.careTipsController,
    required this.reminderController,
    required this.adoptionController,
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
    required this.dailyCheckinController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('profile')),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationsScreen(controller: notificationController)),
            ),
            icon: const Icon(Icons.notifications_none),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 12))],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544723795-3fb6469f5b39'),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Guest Lover', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 4),
                    Text('guest@pawadopt.app'),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 18),
          _sectionTitle(t('quick_actions')),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _ActionCard(
                icon: Icons.space_dashboard_rounded,
                color: Colors.deepPurple,
                title: t('dashboard'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardScreen(
                      petController: petController,
                      reminderController: reminderController,
                      careTipsController: careTipsController,
                      adoptionController: adoptionController,
                      serviceController: serviceController,
                      notificationController: notificationController,
                      journalController: journalController,
                      achievementsController: achievementsController,
                      timelineController: timelineController,
                      galleryController: galleryController,
                      carePlannerController: carePlannerController,
                      suppliesController: suppliesController,
                      emergencyController: emergencyController,
                      mealPlanController: mealPlanController,
                      vetVisitController: vetVisitController,
                      communityController: communityController,
                      insightsController: insightsController,
                    ),
                  ),
                ),
              ),
              _ActionCard(
                icon: Icons.pets_outlined,
                color: Colors.teal,
                title: t('my_pets'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyPetsScreen(
                      petController: petController,
                      adoptionController: adoptionController,
                      reminderController: reminderController,
                    ),
                  ),
                ),
              ),
              _ActionCard(
                icon: Icons.bolt_rounded,
                color: Colors.orange,
                title: t('care_planner'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarePlannerScreen(controller: carePlannerController),
                  ),
                ),
              ),
              _ActionCard(
                icon: Icons.inventory_2_outlined,
                color: Colors.indigo,
                title: t('supplies'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SuppliesScreen(controller: suppliesController)),
                ),
              ),
                _ActionCard(
                  icon: Icons.health_and_safety_outlined,
                  color: Colors.redAccent,
                  title: t('emergency_ready'),
                  onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmergencyScreen(controller: emergencyController)),
                ),
              ),
                _ActionCard(
                  icon: Icons.donut_small_outlined,
                  color: Colors.amber,
                  title: t('insights'),
                  onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InsightsScreen(controller: insightsController)),
                  ),
                ),
                _ActionCard(
                  icon: Icons.local_hospital_outlined,
                  color: Colors.redAccent,
                  title: t('vet_visits'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VetVisitsScreen(controller: vetVisitController)),
                  ),
                ),
                _ActionCard(
                icon: Icons.restaurant_menu_rounded,
                color: Colors.orange,
                title: t('meal_plan'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MealPlanScreen(controller: mealPlanController)),
                ),
              ),
              _ActionCard(
                icon: Icons.checklist_rtl_rounded,
                color: Colors.lightGreen,
                title: t('daily_checkins'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DailyCheckinScreen(controller: dailyCheckinController)),
                ),
              ),
              _ActionCard(
                icon: Icons.celebration_outlined,
                color: Colors.deepOrange,
                title: t('community_events'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CommunityEventsScreen(controller: communityController)),
                ),
              ),
              _ActionCard(
                icon: Icons.favorite,
                color: Colors.pinkAccent,
                title: t('favorites'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoritesScreen(
                      controller: petController,
                      adoptionController: adoptionController,
                      reminderController: reminderController,
                    ),
                  ),
                ),
              ),
              _ActionCard(
                icon: Icons.article_rounded,
                color: Colors.orangeAccent,
                title: t('care_tips'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CareTipsScreen(controller: careTipsController)),
                ),
              ),
              _ActionCard(
                icon: Icons.alarm,
                color: Colors.green,
                title: t('reminders'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RemindersScreen(controller: reminderController)),
                ),
              ),
              _ActionCard(
                icon: Icons.assignment_turned_in_outlined,
                color: Colors.blueAccent,
                title: t('adoption_requests'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdoptionRequestsScreen(controller: adoptionController)),
                ),
              ),
              _ActionCard(
                icon: Icons.notifications_rounded,
                color: Colors.deepOrange,
                title: t('notifications'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen(controller: notificationController)),
                ),
              ),
              _ActionCard(
                icon: Icons.book_outlined,
                color: Colors.brown,
                title: t('journal'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PetJournalScreen(controller: journalController)),
                ),
              ),
              _ActionCard(
                icon: Icons.emoji_events_outlined,
                color: Colors.amber,
                title: t('achievements'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AchievementsScreen(controller: achievementsController)),
                ),
              ),
              _ActionCard(
                icon: Icons.timeline,
                color: Colors.cyan,
                title: t('timeline'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActivityTimelineScreen(controller: timelineController)),
                ),
              ),
              _ActionCard(
                icon: Icons.photo_library_rounded,
                color: Colors.pinkAccent,
                title: t('gallery'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PetGalleryScreen(controller: galleryController)),
                ),
              ),
              _ActionCard(
                icon: Icons.health_and_safety_rounded,
                color: Colors.orange,
                title: t('health_records'),
                onTap: () => Navigator.pushNamed(context, '/care/health'),
              ),
              _ActionCard(
                icon: Icons.school_rounded,
                color: Colors.indigo,
                title: t('training'),
                onTap: () => Navigator.pushNamed(context, '/training'),
              ),
              _ActionCard(
                icon: Icons.support_agent_rounded,
                color: Colors.blueGrey,
                title: t('help_center'),
                onTap: () => Navigator.pushNamed(context, '/support/faq'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _sectionTitle(t('your_pets')),
          SizedBox(
            height: 160,
            child: StreamBuilder<List<Pet>>(
              stream: petController.petsStream,
              builder: (context, snapshot) {
                final pets = snapshot.data ?? [];
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(pet.imageUrl, width: double.infinity, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(pet.name),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(t('pet_care_nearby')),
          StreamBuilder<List<PetService>>(
            stream: serviceController.servicesStream,
            builder: (context, snapshot) {
              final services = snapshot.data ?? [];
              return Column(
                children: services
                    .take(2)
                    .map((s) => ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(s.imageUrl)),
                          title: Text(s.name),
                          subtitle: Text('${s.distanceKm} km'),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  localeController: localeController,
                  themeController: themeController,
                ),
              ),
            ),
            child: Text(t('settings')),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      );
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.color, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.18),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
