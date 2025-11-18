class PetAchievement {
  final String id;
  final String title;
  final String description;
  final double progress;
  final String reward;
  final String iconUrl;
  final bool completed;

  const PetAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.reward,
    required this.iconUrl,
    this.completed = false,
  });

  PetAchievement copyWith({double? progress, bool? completed}) {
    return PetAchievement(
      id: id,
      title: title,
      description: description,
      progress: progress ?? this.progress,
      reward: reward,
      iconUrl: iconUrl,
      completed: completed ?? this.completed,
    );
  }
}
