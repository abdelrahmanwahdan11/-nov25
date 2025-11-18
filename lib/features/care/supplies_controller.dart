import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_supplies.dart';
import '../../data/models/pet_supply.dart';

class SuppliesController extends ChangeNotifier {
  final _stream = StreamController<List<PetSupply>>.broadcast();
  List<PetSupply> _items = [];
  bool isLoading = false;

  Stream<List<PetSupply>> get suppliesStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 420));
    if (_items.isEmpty) {
      _items = List.from(mockSupplies);
    }
    isLoading = false;
    _push();
  }

  void restock(PetSupply supply, {int amount = 1}) {
    _items = _items
        .map((s) => s.id == supply.id
            ? s.copyWith(
                quantity: s.quantity + amount,
                lowStock: s.quantity + amount < 5 ? true : false,
              )
            : s)
        .toList();
    _push();
  }

  void consume(PetSupply supply, {int amount = 1}) {
    final next = supply.quantity - amount;
    _items = _items
        .map((s) => s.id == supply.id
            ? s.copyWith(
                quantity: next < 0 ? 0 : next,
                lowStock: (next < 5),
              )
            : s)
        .toList();
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
