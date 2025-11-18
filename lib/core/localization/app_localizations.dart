import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const _translations = {
    'en': {
      'discover_title': 'Discover',
      'discover_subtitle': 'Find a new pet for you',
      'see_more': 'See more',
      'your_pets': 'Your pets',
      'pet_care_nearby': 'Pet care nearby',
      'login': 'Login',
      'signup': 'Sign up',
      'login_as_guest': 'Continue as guest',
      'forgot_password': 'Forgot password?',
      'settings': 'Settings',
      'dark_mode': 'Dark mode',
      'language': 'Language',
      'primary_color': 'Primary color',
      'compare': 'Compare',
      'adopt': 'Adopt',
      'ai_info': 'AI info',
      'catalog': 'Catalog',
      'profile': 'Profile',
      'home': 'Home',
      'get_started': 'Get Started',
      'next': 'Next',
      'skip': 'Skip',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'confirm_password': 'Confirm password',
      'guest_hint': 'Browse quickly without account',
      'compare_hint': 'Select at least 2 pets to compare.',
    },
    'ar': {
      'discover_title': 'اكتشف',
      'discover_subtitle': 'ابحث عن حيوان أليف مناسب لك',
      'see_more': 'عرض المزيد',
      'your_pets': 'حيواناتك الأليفة',
      'pet_care_nearby': 'خدمات رعاية قريبة',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'login_as_guest': 'المتابعة كضيف',
      'forgot_password': 'نسيت كلمة المرور؟',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الداكن',
      'language': 'اللغة',
      'primary_color': 'اللون الرئيسي',
      'compare': 'مقارنة',
      'adopt': 'تبنّي',
      'ai_info': 'معلومات بالذكاء الاصطناعي',
      'catalog': 'الفهرس',
      'profile': 'الملف الشخصي',
      'home': 'الرئيسية',
      'get_started': 'ابدأ',
      'next': 'التالي',
      'skip': 'تخطي',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'name': 'الاسم',
      'confirm_password': 'تأكيد كلمة المرور',
      'guest_hint': 'تصفح سريع دون حساب',
      'compare_hint': 'اختر حيوانين على الأقل للمقارنة.',
    }
  };

  String t(String key) => _translations[locale.languageCode]?[key] ??
      _translations['en']![key] ?? key;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
