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
import 'features/care/health_controller.dart';
import 'features/adoption/adoption_controller.dart';
import 'features/adoption/adoption_requests_screen.dart';
import 'features/home/dashboard_screen.dart';
import 'features/profile/my_pets_screen.dart';
import 'features/services/service_details_screen.dart';
import 'features/care/health_records_screen.dart';
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
  late final HealthController healthController;
  late final TrainingController trainingController;
  late final FaqController faqController;
  late final NotificationController notificationController;
  late final JournalController journalController;
  late final AchievementsController achievementsController;
  late final TimelineController timelineController;
  late final GalleryController galleryController;

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
    healthController = HealthController()..load();
    trainingController = TrainingController()..load();
    faqController = FaqController()..load();
    notificationController = NotificationController()..load();
    journalController = JournalController()..load();
    achievementsController = AchievementsController()..load();
    timelineController = TimelineController()..load();
    galleryController = GalleryController()..load();
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
                  healthController: healthController,
                  trainingController: trainingController,
                  faqController: faqController,
                  notificationController: notificationController,
                  journalController: journalController,
                  achievementsController: achievementsController,
                  timelineController: timelineController,
                  galleryController: galleryController,
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
            '/care/health': (_) => HealthRecordsScreen(controller: healthController),
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
  final HealthController healthController;
  final TrainingController trainingController;
  final FaqController faqController;
  final NotificationController notificationController;
  final JournalController journalController;
  final AchievementsController achievementsController;
  final TimelineController timelineController;
  final GalleryController galleryController;
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
    required this.healthController,
    required this.trainingController,
    required this.faqController,
    required this.notificationController,
    required this.journalController,
    required this.achievementsController,
    required this.timelineController,
    required this.galleryController,
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
