import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_meal_plan.dart';
import '../../data/models/meal_plan_item.dart';

class MealPlanController extends ChangeNotifier {
  final _stream = StreamController<List<MealPlanItem>>.broadcast();
  List<MealPlanItem> _items = [];
  bool isLoading = false;

  Stream<List<MealPlanItem>> get itemsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 450));
    if (_items.isEmpty) {
      _items = List.from(mockMealPlan);
    }
    isLoading = false;
    _push();
  }

  void toggleDone(MealPlanItem item) {
    _items = _items.map((m) => m.id == item.id ? m.copyWith(isDone: !m.isDone) : m).toList();
    _push();
  }

  void addItem(MealPlanItem item) {
    _items = [..._items, item];
    _push();
  }

  void _push() {
    _stream.add(List.from(_items));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
