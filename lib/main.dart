import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_controller.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/auth_controller.dart';
import 'features/home/bottom_nav_controller.dart';
import 'features/home/home_discover_screen.dart';
import 'features/catalog/catalog_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/splash_decider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/compare/compare_screen.dart';
import 'features/pet_details/pet_details_screen.dart';
import 'features/services/pet_care_nearby_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/home/pet_controller.dart';
import 'features/services/service_controller.dart';
import 'core/widgets/soft_bottom_nav.dart';
import 'features/home/favorites_screen.dart';
import 'features/care/care_tips_screen.dart';
import 'features/care/reminders_screen.dart';
import 'features/care/care_tips_controller.dart';
import 'features/care/reminder_controller.dart';
import 'features/care/care_planner_controller.dart';
import 'features/care/health_controller.dart';
import 'features/care/meal_plan_controller.dart';
import 'features/adoption/adoption_controller.dart';
import 'features/adoption/adoption_requests_screen.dart';
import 'features/home/dashboard_screen.dart';
import 'features/profile/my_pets_screen.dart';
import 'features/services/service_details_screen.dart';
import 'features/care/health_records_screen.dart';
import 'features/care/meal_plan_screen.dart';
import 'features/training/training_controller.dart';
import 'features/training/training_screen.dart';
import 'features/support/faq_controller.dart';
import 'features/support/faq_support_screen.dart';
import 'features/notifications/notification_controller.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/journal/journal_controller.dart';
import 'features/journal/pet_journal_screen.dart';
import 'features/achievements/achievements_controller.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/timeline/timeline_controller.dart';
import 'features/timeline/activity_timeline_screen.dart';
import 'features/gallery/gallery_controller.dart';
import 'features/gallery/pet_gallery_screen.dart';
import 'features/care/care_planner_screen.dart';
import 'features/care/supplies_controller.dart';
import 'features/care/supplies_screen.dart';
import 'features/care/emergency_controller.dart';
import 'features/care/emergency_screen.dart';
import 'features/care/vet_visit_controller.dart';
import 'features/care/vet_visits_screen.dart';
import 'features/care/daily_checkin_controller.dart';
import 'features/care/daily_checkin_screen.dart';
import 'features/community/community_controller.dart';
import 'features/community/community_events_screen.dart';
import 'features/insights/insights_controller.dart';
import 'features/insights/insights_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  final localeController = LocaleController();
  await themeController.load();
  await localeController.load();
  runApp(PawAdoptApp(
    themeController: themeController,
    localeController: localeController,
  ));
}

class PawAdoptApp extends StatefulWidget {
  final ThemeController themeController;
  final LocaleController localeController;
  const PawAdoptApp({super.key, required this.themeController, required this.localeController});

  @override
  State<PawAdoptApp> createState() => _PawAdoptAppState();
}

class _PawAdoptAppState extends State<PawAdoptApp> {
  late final AuthController authController;
  late final PetController petController;
  late final ServiceController serviceController;
  late final BottomNavController navController;
  late final CareTipsController careTipsController;
  late final ReminderController reminderController;
  late final AdoptionController adoptionController;
  late final CarePlannerController carePlannerController;
  late final HealthController healthController;
  late final MealPlanController mealPlanController;
  late final TrainingController trainingController;
  late final FaqController faqController;
  late final NotificationController notificationController;
  late final JournalController journalController;
  late final AchievementsController achievementsController;
  late final TimelineController timelineController;
  late final GalleryController galleryController;
  late final SuppliesController suppliesController;
  late final EmergencyController emergencyController;
  late final VetVisitController vetVisitController;
  late final CommunityController communityController;
  late final InsightsController insightsController;
  late final DailyCheckinController dailyCheckinController;

  @override
  void initState() {
    super.initState();
    authController = AuthController();
    petController = PetController()..loadInitialPets();
    serviceController = ServiceController()..loadInitialServices();
    navController = BottomNavController();
    careTipsController = CareTipsController()..load();
    reminderController = ReminderController()..load();
    adoptionController = AdoptionController()..load();
    carePlannerController = CarePlannerController()..load();
    healthController = HealthController()..load();
    mealPlanController = MealPlanController()..load();
    trainingController = TrainingController()..load();
    faqController = FaqController()..load();
    notificationController = NotificationController()..load();
    journalController = JournalController()..load();
    achievementsController = AchievementsController()..load();
    timelineController = TimelineController()..load();
    galleryController = GalleryController()..load();
    suppliesController = SuppliesController()..load();
    emergencyController = EmergencyController()..load();
    vetVisitController = VetVisitController()..load();
    communityController = CommunityController()..load();
    insightsController = InsightsController()..load();
    dailyCheckinController = DailyCheckinController()..load();
  }

  @override
  void dispose() {
    petController.dispose();
    serviceController.dispose();
    navController.dispose();
    careTipsController.dispose();
    reminderController.dispose();
    adoptionController.dispose();
    healthController.dispose();
    trainingController.dispose();
    faqController.dispose();
    notificationController.dispose();
    journalController.dispose();
    achievementsController.dispose();
    timelineController.dispose();
    galleryController.dispose();
    carePlannerController.dispose();
    suppliesController.dispose();
    emergencyController.dispose();
    mealPlanController.dispose();
    vetVisitController.dispose();
    communityController.dispose();
    insightsController.dispose();
    dailyCheckinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController;
    final localeCtrl = widget.localeController;
    return AnimatedBuilder(
      animation: Listenable.merge([theme, localeCtrl]),
      builder: (context, _) {
        final locale = localeCtrl.locale;
        return MaterialApp(
          title: 'PawAdopt',
          debugShowCheckedModeBanner: false,
          theme: theme.buildTheme(Brightness.light).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(theme.buildTheme(Brightness.light).textTheme),
          ),
          darkTheme: theme.buildTheme(Brightness.dark).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(theme.buildTheme(Brightness.dark).textTheme),
          ),
          themeMode: theme.themeMode,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routes: {
            '/': (_) => SplashDecider(localeController: localeCtrl),
            '/onboarding': (_) => OnboardingScreen(localeController: localeCtrl),
            '/auth/login': (_) => LoginScreen(authController: authController),
            '/auth/signup': (_) => SignUpScreen(authController: authController),
            '/auth/forgot': (_) => ForgotPasswordScreen(),
            '/home': (_) => RootShell(
                  themeController: theme,
                  localeController: localeCtrl,
                  navController: navController,
                  petController: petController,
                  serviceController: serviceController,
                  careTipsController: careTipsController,
                  reminderController: reminderController,
                  adoptionController: adoptionController,
                  carePlannerController: carePlannerController,
                  healthController: healthController,
                  mealPlanController: mealPlanController,
                  trainingController: trainingController,
                  faqController: faqController,
                  notificationController: notificationController,
                  journalController: journalController,
                  achievementsController: achievementsController,
                  timelineController: timelineController,
                  galleryController: galleryController,
                  suppliesController: suppliesController,
                  emergencyController: emergencyController,
                ),
            '/dashboard': (_) => DashboardScreen(
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
                  dailyCheckinController: dailyCheckinController,
                ),
            '/my-pets': (_) => MyPetsScreen(
                  petController: petController,
                  adoptionController: adoptionController,
                  reminderController: reminderController,
                ),
            '/pet/compare': (_) => CompareScreen(petController: petController),
            '/services': (_) => PetCareNearbyScreen(serviceController: serviceController),
            '/services/details': (context) => const ServiceDetailsScreen(),
            '/settings': (_) => SettingsScreen(
                  localeController: localeCtrl,
                  themeController: theme,
                ),
            '/favorites': (_) => FavoritesScreen(
                  controller: petController,
                  adoptionController: adoptionController,
                  reminderController: reminderController,
                ),
            '/care/tips': (_) => CareTipsScreen(controller: careTipsController),
            '/care/reminders': (_) => RemindersScreen(controller: reminderController),
            '/care/planner': (_) => CarePlannerScreen(controller: carePlannerController),
            '/care/meals': (_) => MealPlanScreen(controller: mealPlanController),
            '/care/supplies': (_) => SuppliesScreen(controller: suppliesController),
            '/care/emergency': (_) => EmergencyScreen(controller: emergencyController),
            '/care/vet-visits': (_) => VetVisitsScreen(controller: vetVisitController),
            '/care/checkins': (_) => DailyCheckinScreen(controller: dailyCheckinController),
            '/care/health': (_) => HealthRecordsScreen(controller: healthController),
            '/community': (_) => CommunityEventsScreen(controller: communityController),
            '/insights': (_) => InsightsScreen(controller: insightsController),
            '/adoption/requests': (_) => AdoptionRequestsScreen(controller: adoptionController),
            '/training': (_) => TrainingScreen(controller: trainingController),
            '/support/faq': (_) => FaqSupportScreen(controller: faqController),
            '/notifications': (_) => NotificationsScreen(controller: notificationController),
            '/journal': (_) => PetJournalScreen(controller: journalController),
            '/achievements': (_) => AchievementsScreen(controller: achievementsController),
            '/timeline': (_) => ActivityTimelineScreen(controller: timelineController),
            '/gallery': (_) => PetGalleryScreen(controller: galleryController),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/pet/details' && settings.arguments is PetDetailsArgs) {
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => PetDetailsScreen(args: settings.arguments as PetDetailsArgs),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return null;
          },
        );
      },
    );
  }
}

class RootShell extends StatelessWidget {
  final ThemeController themeController;
  final LocaleController localeController;
  final BottomNavController navController;
  final PetController petController;
  final ServiceController serviceController;
  final CareTipsController careTipsController;
  final ReminderController reminderController;
  final AdoptionController adoptionController;
  final CarePlannerController carePlannerController;
  final HealthController healthController;
  final TrainingController trainingController;
  final FaqController faqController;
  final NotificationController notificationController;
  final JournalController journalController;
  final AchievementsController achievementsController;
  final TimelineController timelineController;
  final GalleryController galleryController;
  final SuppliesController suppliesController;
  final EmergencyController emergencyController;
  final MealPlanController mealPlanController;
  final VetVisitController vetVisitController;
  final CommunityController communityController;
  final InsightsController insightsController;
  final DailyCheckinController dailyCheckinController;
  const RootShell({
    super.key,
    required this.themeController,
    required this.localeController,
    required this.navController,
    required this.petController,
    required this.serviceController,
    required this.careTipsController,
    required this.reminderController,
    required this.adoptionController,
    required this.carePlannerController,
    required this.healthController,
    required this.trainingController,
    required this.faqController,
    required this.notificationController,
    required this.journalController,
    required this.achievementsController,
    required this.timelineController,
    required this.galleryController,
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
    final pages = [
      HomeDiscoverScreen(
        petController: petController,
        adoptionController: adoptionController,
        reminderController: reminderController,
        notificationController: notificationController,
        journalController: journalController,
        achievementsController: achievementsController,
        timelineController: timelineController,
        galleryController: galleryController,
        carePlannerController: carePlannerController,
        suppliesController: suppliesController,
        emergencyController: emergencyController,
        communityController: communityController,
        insightsController: insightsController,
        mealPlanController: mealPlanController,
        vetVisitController: vetVisitController,
        dailyCheckinController: dailyCheckinController,
      ),
      CatalogScreen(
        petController: petController,
        adoptionController: adoptionController,
        reminderController: reminderController,
      ),
      ProfileScreen(
        petController: petController,
        serviceController: serviceController,
        themeController: themeController,
        localeController: localeController,
        careTipsController: careTipsController,
        reminderController: reminderController,
        adoptionController: adoptionController,
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
        dailyCheckinController: dailyCheckinController,
      ),
    ];
    return Scaffold(
      body: AnimatedBuilder(
        animation: navController,
        builder: (_, __) => IndexedStack(index: navController.index, children: pages),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: navController,
        builder: (_, __) => SoftBottomNav(
          index: navController.index,
          onChanged: (i) => navController.setIndex(i),
        ),
      ),
    );
  }
}
