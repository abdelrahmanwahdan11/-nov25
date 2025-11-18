import 'package:flutter/material.dart';
import '../../data/models/app_user.dart';

class AuthController extends ChangeNotifier {
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Min 6 chars';
    return null;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AppUser(
      id: 'u1',
      name: 'Guest Lover',
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
      isGuest: false,
    );
    notifyListeners();
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AppUser(
      id: 'u2',
      name: name,
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      isGuest: false,
    );
    notifyListeners();
    return true;
  }

  void loginAsGuest() {
    _currentUser = AppUser(
      id: 'guest',
      name: 'Guest',
      email: 'guest@pawadopt.app',
      avatarUrl: 'https://images.unsplash.com/photo-1504208434309-cb69f4fe52b0',
      isGuest: true,
    );
    notifyListeners();
  }
}
