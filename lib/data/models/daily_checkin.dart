class DailyCheckin {
  final String id;
  final String petName;
  final String title;
  final String timeLabel;
  final String mood;
  final String note;
  final bool completed;

  DailyCheckin({
    required this.id,
    required this.petName,
    required this.title,
    required this.timeLabel,
    required this.mood,
    required this.note,
    required this.completed,
  });

  DailyCheckin copyWith({bool? completed}) {
    return DailyCheckin(
      id: id,
      petName: petName,
      title: title,
      timeLabel: timeLabel,
      mood: mood,
      note: note,
      completed: completed ?? this.completed,
    );
  }
}
