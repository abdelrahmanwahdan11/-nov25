import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final _streamController = StreamController<Locale>.broadcast();
  static const _localeKey = 'locale_code';

  Locale get locale => _locale;
  Stream<Locale> get localeStream => _streamController.stream;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_localeKey);
    if (stored != null) {
      _locale = Locale(stored);
    }
    _streamController.add(_locale);
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    _streamController.add(_locale);
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
