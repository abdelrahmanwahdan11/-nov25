import '../models/pet_journal_entry.dart';

final mockJournalEntries = [
  PetJournalEntry(
    id: 'j1',
    petName: 'Luna',
    title: 'Morning walk',
    note: 'Short walk with light jogging, Luna was energetic and friendly.',
    mood: '😊',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  PetJournalEntry(
    id: 'j2',
    petName: 'Rocky',
    title: 'Training recap',
    note: 'Practiced sit, stay, and recall. Rewarded with treats.',
    mood: '💪',
    createdAt: DateTime.now().subtract(const Duration(hours: 20)),
  ),
  PetJournalEntry(
    id: 'j3',
    petName: 'Bella',
    title: 'Vet follow-up',
    note: 'Weight is stable, vet recommends more hydration.',
    mood: '🩺',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
