import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_care_tips.dart';
import '../../data/models/care_tip.dart';

class CareTipsController extends ChangeNotifier {
  final _stream = StreamController<List<CareTip>>.broadcast();
  List<CareTip> _tips = [];
  String? _filterCategory;
  bool isLoading = false;

  Stream<List<CareTip>> get tipsStream => _stream.stream;
  String? get filter => _filterCategory;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 600));
    _tips = List.from(mockCareTips);
    isLoading = false;
    _push();
  }

  void filterByCategory(String? category) {
    _filterCategory = category;
    _push();
  }

  void toggleComplete(CareTip tip) {
    _tips = _tips.map((t) => t.id == tip.id ? t.copyWith(isCompleted: !t.isCompleted) : t).toList();
    _push();
  }

  List<CareTip> _filtered() {
    if (_filterCategory == null) return _tips;
    return _tips.where((t) => t.category == _filterCategory).toList();
  }

  void _push() {
    _stream.add(List.from(_filtered()));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
