import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = const Color(0xFFF2C3A5);
  final _streamController = StreamController<ThemeData>.broadcast();

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  Stream<ThemeData> get themeStream => _streamController.stream;

  static const _themeKey = 'theme_mode';
  static const _colorKey = 'primary_color';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMode = prefs.getString(_themeKey);
    final storedColor = prefs.getInt(_colorKey);
    if (storedMode != null) {
      _themeMode = storedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
    if (storedColor != null) {
      _primaryColor = Color(storedColor);
    }
    _pushTheme();
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persist();
    _pushTheme();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _persist();
    _pushTheme();
    notifyListeners();
  }

  ThemeData buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scaffold = isDark ? const Color(0xFF181313) : const Color(0xFFF2C3A5);
    final card = isDark ? const Color(0xFF262020) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF121212);
    final textSecondary = isDark ? const Color(0xFFCCCCCC) : const Color(0xFF6B6B6B);

    return ThemeData(
      brightness: brightness,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: brightness,
        background: scaffold,
      ),
      scaffoldBackgroundColor: scaffold,
      cardColor: card,
      textTheme: ThemeData(brightness: brightness)
          .textTheme
          .apply(bodyColor: textPrimary, displayColor: textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryColor.withOpacity(0.12),
        selectedColor: _primaryColor,
        labelStyle: TextStyle(color: textPrimary),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: _primaryColor),
    );
  }

  void _pushTheme() {
    _streamController.add(buildTheme(
        _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light));
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeMode == ThemeMode.dark ? 'dark' : 'light');
    await prefs.setInt(_colorKey, _primaryColor.value);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
