import '../models/pet_moment.dart';

final mockPetMoments = [
  PetMoment(
    id: 'm1',
    petName: 'Luna',
    imageUrl: 'https://images.unsplash.com/photo-1612831662375-295c1003d3ca?auto=format&fit=crop&w=600&q=80',
    caption: 'Sunset zoomies at the beach.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likes: 12,
  ),
  PetMoment(
    id: 'm2',
    petName: 'Milo',
    imageUrl: 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7?auto=format&fit=crop&w=600&q=80',
    caption: 'Post-training nap champion.',
    createdAt: DateTime.now().subtract(const Duration(hours: 7)),
    likes: 8,
  ),
  PetMoment(
    id: 'm3',
    petName: 'Bella',
    imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=600&q=80',
    caption: 'Spa day glow up.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likes: 21,
  ),
  PetMoment(
    id: 'm4',
    petName: 'Luna',
    imageUrl: 'https://images.unsplash.com/photo-1501973801540-537f08ccae7b?auto=format&fit=crop&w=600&q=80',
    caption: 'Early walk rewards with treats.',
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    likes: 15,
  ),
];
