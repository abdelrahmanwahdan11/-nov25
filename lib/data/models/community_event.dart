class CommunityEvent {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final double distanceKm;
  final String imageUrl;
  final String description;
  final bool isOnline;
  final List<String> tags;
  final bool saved;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.distanceKm,
    required this.imageUrl,
    required this.description,
    required this.isOnline,
    required this.tags,
    this.saved = false,
  });

  CommunityEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? location,
    double? distanceKm,
    String? imageUrl,
    String? description,
    bool? isOnline,
    List<String>? tags,
    bool? saved,
  }) {
    return CommunityEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isOnline: isOnline ?? this.isOnline,
      tags: tags ?? this.tags,
      saved: saved ?? this.saved,
    );
  }
}
