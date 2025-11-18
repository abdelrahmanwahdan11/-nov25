import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_pets.dart';
import '../../data/models/pet.dart';

class PetController extends ChangeNotifier {
  final _petsStream = StreamController<List<Pet>>.broadcast();
  final _compareStream = StreamController<List<Pet>>.broadcast();
  List<Pet> _allPets = [];
  List<Pet> _visiblePets = [];
  List<Pet> _selectedForCompare = [];
  bool isLoading = false;
  int _page = 0;
  static const _pageSize = 10;

  Stream<List<Pet>> get petsStream => _petsStream.stream;
  Stream<List<Pet>> get compareStream => _compareStream.stream;

  Future<void> loadInitialPets() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 800));
    _allPets = List.from(mockPets);
    _page = 1;
    _visiblePets = _allPets.take(_pageSize).toList();
    isLoading = false;
    _push();
  }

  Future<void> refreshPets() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 500));
    _page = 1;
    _visiblePets = _allPets.take(_pageSize).toList();
    isLoading = false;
    _push();
  }

  void loadMorePets() {
    if (_visiblePets.length >= _allPets.length) return;
    _page++;
    final nextCount = _page * _pageSize;
    _visiblePets = _allPets.take(nextCount).toList();
    _push();
  }

  void filterByType(PetType type) {
    _visiblePets = _allPets.where((p) => p.type == type).take(_pageSize).toList();
    _push();
  }

  void searchPets(String query) {
    final lower = query.toLowerCase();
    _visiblePets = _allPets
        .where((p) =>
            p.name.toLowerCase().contains(lower) ||
            p.breed.toLowerCase().contains(lower) ||
            p.shortDescription.toLowerCase().contains(lower) ||
            p.longDescription.toLowerCase().contains(lower))
        .toList();
    _push();
  }

  void toggleFavorite(Pet pet) {
    _allPets = _allPets.map((p) => p.id == pet.id ? p.copyWith(isFavorite: !p.isFavorite) : p).toList();
    _visiblePets = _allPets.take(_visiblePets.length).toList();
    _push();
  }

  void selectForCompare(Pet pet) {
    if (_selectedForCompare.any((p) => p.id == pet.id)) {
      _selectedForCompare.removeWhere((p) => p.id == pet.id);
    } else if (_selectedForCompare.length < 3) {
      _selectedForCompare.add(pet);
    }
    _compareStream.add(List.from(_selectedForCompare));
    notifyListeners();
  }

  void clearCompare() {
    _selectedForCompare.clear();
    _compareStream.add([]);
    notifyListeners();
  }

  List<Pet> get selectedForCompare => _selectedForCompare;

  void _push() {
    _petsStream.add(List.from(_visiblePets));
    notifyListeners();
  }

  @override
  void dispose() {
    _petsStream.close();
    _compareStream.close();
    super.dispose();
  }
}
