import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_reminders.dart';
import '../../data/models/pet_reminder.dart';

class ReminderController extends ChangeNotifier {
  final _stream = StreamController<List<PetReminder>>.broadcast();
  List<PetReminder> _reminders = [];
  bool isLoading = false;

  Stream<List<PetReminder>> get remindersStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 400));
    if (_reminders.isEmpty) {
      _reminders = List.from(mockReminders);
    }
    isLoading = false;
    _push();
  }

  void toggleDone(PetReminder reminder) {
    _reminders = _reminders.map((r) => r.id == reminder.id ? r.copyWith(isDone: !r.isDone) : r).toList();
    _push();
  }

  void addReminder(PetReminder reminder) {
    _reminders = [..._reminders, reminder];
    _push();
  }

  void _push() {
    _stream.add(List.from(_reminders));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
