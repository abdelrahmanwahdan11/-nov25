class PetJournalEntry {
  final String id;
  final String petName;
  final String title;
  final String note;
  final String mood;
  final DateTime createdAt;

  const PetJournalEntry({
    required this.id,
    required this.petName,
    required this.title,
    required this.note,
    required this.mood,
    required this.createdAt,
  });

  PetJournalEntry copyWith({String? note, String? title}) => PetJournalEntry(
        id: id,
        petName: petName,
        title: title ?? this.title,
        note: note ?? this.note,
        mood: mood,
        createdAt: createdAt,
      );
}
