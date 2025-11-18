import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_vet_visits.dart';
import '../../data/models/vet_visit.dart';

class VetVisitController extends ChangeNotifier {
  final _stream = StreamController<List<VetVisit>>.broadcast();
  List<VetVisit> _visits = [];
  bool isLoading = false;

  Stream<List<VetVisit>> get visitsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 500));
    if (_visits.isEmpty) {
      _visits = List.from(mockVetVisits);
    }
    isLoading = false;
    _push();
  }

  void markCompleted(VetVisit visit) {
    _visits = _visits.map((v) => v.id == visit.id ? v.copyWith(status: 'completed') : v).toList();
    _push();
  }

  void markUrgent(VetVisit visit) {
    _visits = _visits.map((v) => v.id == visit.id ? v.copyWith(status: 'urgent') : v).toList();
    _push();
  }

  void addVisit(VetVisit visit) {
    _visits = [..._visits, visit];
    _push();
  }

  void _push() {
    _stream.add(List.from(_visits));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
