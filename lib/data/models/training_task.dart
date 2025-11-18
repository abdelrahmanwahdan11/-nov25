class TrainingTask {
  final String id;
  final String title;
  final String level; // beginner/intermediate/advanced
  final String petName;
  final double progress; // 0-1
  final List<String> steps;
  final bool completed;

  const TrainingTask({
    required this.id,
    required this.title,
    required this.level,
    required this.petName,
    required this.progress,
    required this.steps,
    this.completed = false,
  });

  TrainingTask copyWith({double? progress, bool? completed}) {
    return TrainingTask(
      id: id,
      title: title,
      level: level,
      petName: petName,
      progress: progress ?? this.progress,
      steps: steps,
      completed: completed ?? this.completed,
    );
  }
}
