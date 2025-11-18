class PetService {
  final String id;
  final String name;
  final double distanceKm;
  final double rating;
  final String imageUrl;
  final List<String> services;
  final String description;

  PetService({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.rating,
    required this.imageUrl,
    required this.services,
    required this.description,
  });
}
