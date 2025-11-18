class TimelineEvent {
  final String id;
  final String petName;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  final String accent;

  const TimelineEvent({
    required this.id,
    required this.petName,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    required this.accent,
  });
}
