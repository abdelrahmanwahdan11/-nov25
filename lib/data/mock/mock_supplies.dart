import '../models/pet_supply.dart';

final mockSupplies = [
  PetSupply(
    id: 's1',
    name: 'Kibble - Salmon',
    category: 'Food',
    quantity: 2,
    unit: 'bags',
    lowStock: true,
    imageUrl: 'https://images.unsplash.com/photo-1516684669134-de6f27a23d06',
    note: 'Order grain-free version for Bella.',
  ),
  PetSupply(
    id: 's2',
    name: 'Dental sticks',
    category: 'Treats',
    quantity: 18,
    unit: 'pieces',
    lowStock: false,
    imageUrl: 'https://images.unsplash.com/photo-1588515613091-8c5893e7c61b',
    note: 'Use after evening meals only.',
  ),
  PetSupply(
    id: 's3',
    name: 'Shampoo - Oatmeal',
    category: 'Grooming',
    quantity: 1,
    unit: 'bottle',
    lowStock: false,
    imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9',
    note: 'Patch test first for Milo.',
  ),
  PetSupply(
    id: 's4',
    name: 'Waste bags',
    category: 'Walks',
    quantity: 40,
    unit: 'bags',
    lowStock: false,
    imageUrl: 'https://images.unsplash.com/photo-1523419400522-3177f5c1f9b4',
    note: 'Restock monthly.',
  ),
];
