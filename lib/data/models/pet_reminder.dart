class PetReminder {
  final String id;
  final String title;
  final String timeLabel;
  final String type;
  final bool isDone;

  const PetReminder({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.type,
    this.isDone = false,
  });

  PetReminder copyWith({bool? isDone}) => PetReminder(
        id: id,
        title: title,
        timeLabel: timeLabel,
        type: type,
        isDone: isDone ?? this.isDone,
      );
}
