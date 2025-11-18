import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_localizations.dart';

class SplashDecider extends StatefulWidget {
  final dynamic localeController;
  const SplashDecider({super.key, this.localeController});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    if (seen) {
      Navigator.pushReplacementNamed(context, '/auth/login');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(t('dashboard_greeting')),
          ],
        ),
      ),
    );
  }
}
