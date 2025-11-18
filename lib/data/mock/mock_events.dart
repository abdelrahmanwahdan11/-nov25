import '../models/community_event.dart';

final mockCommunityEvents = [
  CommunityEvent(
    id: 'ev1',
    title: 'Sunset Adoption Picnic',
    date: DateTime.now().add(const Duration(days: 2)),
    location: 'Central Park',
    distanceKm: 2.4,
    imageUrl: 'https://images.unsplash.com/photo-1507146426996-ef05306b995a?auto=format&fit=crop&w=900&q=80',
    description: 'Meet adoptable pets, enjoy treats, and join a calm sunset yoga warmup.',
    isOnline: false,
    tags: const ['adoption', 'outdoor', 'family'],
  ),
  CommunityEvent(
    id: 'ev2',
    title: 'Virtual Puppy Training Jam',
    date: DateTime.now().add(const Duration(days: 4)),
    location: 'Live stream',
    distanceKm: 0.0,
    imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=900&q=80',
    description: 'Certified trainer walks you through leash manners and calm greetings.',
    isOnline: true,
    tags: const ['training', 'online'],
  ),
  CommunityEvent(
    id: 'ev3',
    title: 'Wellness Microchip Clinic',
    date: DateTime.now().add(const Duration(days: 7)),
    location: 'Shaded Vet Garden',
    distanceKm: 5.1,
    imageUrl: 'https://images.unsplash.com/photo-1601758064235-0c3b2f31f4cc?auto=format&fit=crop&w=900&q=80',
    description: 'Quick microchips, nail trims, and calm socialization tips from the vets.',
    isOnline: false,
    tags: const ['health', 'clinic'],
  ),
];
