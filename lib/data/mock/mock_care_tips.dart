import '../models/care_tip.dart';

const mockCareTips = [
  CareTip(
    id: 'tip1',
    title: 'Morning walk & bonding',
    category: 'Wellness',
    description: 'Start the day with a gentle 20-minute walk and 5 minutes of positive reinforcement cuddles.',
    imageUrl:
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=60',
    durationMinutes: 20,
  ),
  CareTip(
    id: 'tip2',
    title: 'Brushing session',
    category: 'Grooming',
    description: 'Brush fur in the direction of growth, rewarding calm behaviour and checking for skin irritation.',
    imageUrl:
        'https://images.unsplash.com/photo-1541599188778-cdc73298e8fd?auto=format&fit=crop&w=800&q=60',
    durationMinutes: 10,
  ),
  CareTip(
    id: 'tip3',
    title: 'Hydration check',
    category: 'Health',
    description: 'Refresh the water bowl and add a small ice cube for enrichment on warm days.',
    imageUrl:
        'https://images.unsplash.com/photo-1507146426996-ef05306b995a?auto=format&fit=crop&w=800&q=60',
    durationMinutes: 5,
  ),
  CareTip(
    id: 'tip4',
    title: 'Training micro-session',
    category: 'Training',
    description: 'Practice sit, stay, and recall for 8 minutes using soft treats and plenty of praise.',
    imageUrl:
        'https://images.unsplash.com/photo-1450778869180-41d0601e046e?auto=format&fit=crop&w=800&q=60',
    durationMinutes: 8,
  ),
];
