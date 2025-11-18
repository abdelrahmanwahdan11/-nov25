import '../models/pet_service.dart';

final mockServices = [
  PetService(
    id: 's1',
    name: 'Happy Paws Clinic',
    distanceKm: 1.5,
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1517840545240-472988babdf9',
    services: ['Vaccination', 'Checkup', 'Grooming'],
    description: 'A warm clinic with experienced vets for all family pets.',
  ),
  PetService(
    id: 's2',
    name: 'Splash & Fluff Spa',
    distanceKm: 3.2,
    rating: 4.6,
    imageUrl: 'https://images.unsplash.com/photo-1508672019048-805c876b67e2',
    services: ['Bathing', 'Nail trimming', 'Teeth cleaning'],
    description: 'Soft spa styling inspired by peachy palettes.',
  ),
  PetService(
    id: 's3',
    name: 'Paw Patrol Hotel',
    distanceKm: 5.6,
    rating: 4.4,
    imageUrl: 'https://images.unsplash.com/photo-1507146426996-ef05306b995a',
    services: ['Boarding', 'Walking', 'Playground'],
    description: 'Safe overnight stays with live updates.',
  ),
];
