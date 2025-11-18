import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final dynamic localeController;
  const OnboardingScreen({super.key, this.localeController});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;
  Timer? _timer;

  final _pages = [
    (
      'https://images.unsplash.com/photo-1517849845537-4d257902454a',
      'Discover adorable pets',
      'Find a new pet for you with playful 3D cards.',
    ),
    (
      'https://images.unsplash.com/photo-1517841905240-472988babdf9',
      'Care nearby',
      'Book grooming or vet visits around you.',
    ),
    (
      'https://images.unsplash.com/photo-1507149833265-60c372daea22',
      'Soft peach UI',
      'Relaxing interface with animations and peach gradients.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final next = (_index + 1) % _pages.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await _completeOnboarding();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/auth/login');
                  }
                },
                child: Text(t('skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final item = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(item.$1, fit: BoxFit.cover, width: double.infinity),
                          ).animate().fadeIn(duration: const Duration(milliseconds: 600)).scale(),
                        ),
                        const SizedBox(height: 24),
                        Text(item.$2, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(item.$3, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        height: 10,
                        width: _index == i ? 24 : 10,
                        decoration: BoxDecoration(
                          color: _index == i ? Theme.of(context).primaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_index == _pages.length - 1) {
                        _completeOnboarding();
                        Navigator.pushReplacementNamed(context, '/auth/login');
                      } else {
                        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: Text(_index == _pages.length - 1 ? t('get_started') : t('next')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }
}
