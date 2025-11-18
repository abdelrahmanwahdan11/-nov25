class InsightMetric {
  final String id;
  final String title;
  final String description;
  final double progress;
  final double target;
  final String trend;
  final bool highlight;

  InsightMetric({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.trend,
    this.highlight = false,
  });

  InsightMetric copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    double? target,
    String? trend,
    bool? highlight,
  }) {
    return InsightMetric(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      trend: trend ?? this.trend,
      highlight: highlight ?? this.highlight,
    );
  }
}
