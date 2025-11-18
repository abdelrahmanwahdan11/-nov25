import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_adoption_requests.dart';
import '../../data/models/adoption_request.dart';
import '../../data/models/pet.dart';

class AdoptionController extends ChangeNotifier {
  final _stream = StreamController<List<AdoptionRequest>>.broadcast();
  List<AdoptionRequest> _requests = [];
  bool isLoading = false;

  Stream<List<AdoptionRequest>> get requestsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 500));
    if (_requests.isEmpty) {
      _requests = List.from(mockAdoptionRequests);
    }
    isLoading = false;
    _push();
  }

  void submitRequest(Pet pet, {String note = ''}) {
    final request = AdoptionRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: pet.id,
      petName: pet.name,
      status: 'pending',
      note: note,
      submittedAt: DateTime.now(),
    );
    _requests = [request, ..._requests];
    _push();
  }

  void updateStatus(AdoptionRequest request, String status) {
    _requests = _requests.map((r) => r.id == request.id ? r.copyWith(status: status) : r).toList();
    _push();
  }

  void removeRequest(AdoptionRequest request) {
    _requests = _requests.where((r) => r.id != request.id).toList();
    _push();
  }

  void _push() {
    _stream.add(List.from(_requests));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
