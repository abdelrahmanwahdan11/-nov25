class CarePlanItem {
  final String id;
  final String petName;
  final String title;
  final String category;
  final String scheduledAt;
  final int durationMinutes;
  final String intensity;
  final String note;
  final bool isDone;

  CarePlanItem({
    required this.id,
    required this.petName,
    required this.title,
    required this.category,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.intensity,
    required this.note,
    required this.isDone,
  });

  CarePlanItem copyWith({
    bool? isDone,
  }) {
    return CarePlanItem(
      id: id,
      petName: petName,
      title: title,
      category: category,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      intensity: intensity,
      note: note,
      isDone: isDone ?? this.isDone,
    );
  }
}
