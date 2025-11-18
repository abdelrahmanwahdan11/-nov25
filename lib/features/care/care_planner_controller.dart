import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_care_plan.dart';
import '../../data/models/care_plan_item.dart';

class CarePlannerController extends ChangeNotifier {
  final _stream = StreamController<List<CarePlanItem>>.broadcast();
  List<CarePlanItem> _items = [];
  bool isLoading = false;

  Stream<List<CarePlanItem>> get itemsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 450));
    if (_items.isEmpty) {
      _items = List.from(mockCarePlan);
    }
    isLoading = false;
    _push();
  }

  void toggleDone(CarePlanItem item) {
    _items = _items.map((i) => i.id == item.id ? i.copyWith(isDone: !i.isDone) : i).toList();
    _push();
  }

  void addQuickItem(CarePlanItem item) {
    _items = [item, ..._items];
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
