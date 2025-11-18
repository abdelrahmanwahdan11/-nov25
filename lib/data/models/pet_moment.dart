class PetMoment {
  final String id;
  final String petName;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final int likes;

  const PetMoment({
    required this.id,
    required this.petName,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    this.likes = 0,
  });

  PetMoment copyWith({int? likes}) {
    return PetMoment(
      id: id,
      petName: petName,
      imageUrl: imageUrl,
      caption: caption,
      createdAt: createdAt,
      likes: likes ?? this.likes,
    );
  }
}
