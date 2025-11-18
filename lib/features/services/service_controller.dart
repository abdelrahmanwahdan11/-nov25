import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_services.dart';
import '../../data/models/pet_service.dart';

class ServiceController extends ChangeNotifier {
  final _servicesStream = StreamController<List<PetService>>.broadcast();
  List<PetService> _all = [];
  List<PetService> _visible = [];
  bool isLoading = false;
  int _page = 0;
  static const _pageSize = 10;

  Stream<List<PetService>> get servicesStream => _servicesStream.stream;

  Future<void> loadInitialServices() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 800));
    _all = List.from(mockServices);
    _page = 1;
    _visible = _all.take(_pageSize).toList();
    isLoading = false;
    _push();
  }

  Future<void> refreshServices() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 500));
    _visible = _all.take(_pageSize).toList();
    isLoading = false;
    _push();
  }

  void loadMoreServices() {
    if (_visible.length >= _all.length) return;
    _page++;
    final next = _page * _pageSize;
    _visible = _all.take(next).toList();
    _push();
  }

  void searchServices(String query) {
    final lower = query.toLowerCase();
    _visible = _all
        .where((s) =>
            s.name.toLowerCase().contains(lower) ||
            s.description.toLowerCase().contains(lower) ||
            s.services.any((it) => it.toLowerCase().contains(lower)))
        .toList();
    _push();
  }

  void _push() {
    _servicesStream.add(List.from(_visible));
    notifyListeners();
  }

  @override
  void dispose() {
    _servicesStream.close();
    super.dispose();
  }
}
