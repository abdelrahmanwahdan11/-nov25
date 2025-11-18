import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_emergency_guides.dart';
import '../../data/models/emergency_guide.dart';

class EmergencyController extends ChangeNotifier {
  final _stream = StreamController<List<EmergencyGuide>>.broadcast();
  List<EmergencyGuide> _guides = [];
  bool isLoading = false;

  Stream<List<EmergencyGuide>> get guidesStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 430));
    if (_guides.isEmpty) {
      _guides = List.from(mockEmergencyGuides);
    }
    isLoading = false;
    _push();
  }

  void _push() {
    _stream.add(List.from(_guides));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
