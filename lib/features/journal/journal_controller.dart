import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_journal.dart';
import '../../data/models/pet_journal_entry.dart';

class JournalController extends ChangeNotifier {
  final _stream = StreamController<List<PetJournalEntry>>.broadcast();
  List<PetJournalEntry> _entries = [];
  bool isLoading = false;

  Stream<List<PetJournalEntry>> get entriesStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 600));
    _entries = List.from(mockJournalEntries);
    isLoading = false;
    _push();
  }

  Future<void> refresh() async => load();

  void addEntry({required String petName, required String title, required String note, String mood = '🐾'}) {
    final entry = PetJournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petName: petName,
      title: title,
      note: note,
      mood: mood,
      createdAt: DateTime.now(),
    );
    _entries = [entry, ..._entries];
    _push();
  }

  void _push() {
    _stream.add(List.unmodifiable(_entries));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
