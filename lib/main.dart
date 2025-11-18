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

  @override
  void initState() {
    super.initState();
    authController = AuthController();
    petController = PetController()..loadInitialPets();
    serviceController = ServiceController()..loadInitialServices();
    navController = BottomNavController();
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
            '/': (_) => OnboardingScreen(localeController: localeCtrl),
            '/auth/login': (_) => LoginScreen(authController: authController),
            '/auth/signup': (_) => SignUpScreen(authController: authController),
            '/auth/forgot': (_) => ForgotPasswordScreen(),
            '/home': (_) => RootShell(
                  themeController: theme,
                  localeController: localeCtrl,
                  navController: navController,
                  petController: petController,
                  serviceController: serviceController,
                ),
            '/pet/compare': (_) => CompareScreen(petController: petController),
            '/services': (_) => PetCareNearbyScreen(serviceController: serviceController),
            '/settings': (_) => SettingsScreen(
                  localeController: localeCtrl,
                  themeController: theme,
                ),
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
  const RootShell({
    super.key,
    required this.themeController,
    required this.localeController,
    required this.navController,
    required this.petController,
    required this.serviceController,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDiscoverScreen(petController: petController),
      CatalogScreen(petController: petController),
      ProfileScreen(
        petController: petController,
        serviceController: serviceController,
        themeController: themeController,
        localeController: localeController,
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
