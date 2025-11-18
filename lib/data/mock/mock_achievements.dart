import '../models/pet_achievement.dart';

const mockAchievements = [
  PetAchievement(
    id: 'ach1',
    title: 'Perfect walker',
    description: 'Log 5 long walks this week to keep your buddy active.',
    progress: 0.6,
    reward: 'Peach badge',
    iconUrl: 'https://images.unsplash.com/photo-1525253086316-d0c936c814f8?auto=format&fit=crop&w=400&q=80',
  ),
  PetAchievement(
    id: 'ach2',
    title: 'Vet ready',
    description: 'Upload health notes before your next vet visit.',
    progress: 0.35,
    reward: 'Health star',
    iconUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=400&q=80',
  ),
  PetAchievement(
    id: 'ach3',
    title: 'Trainer in chief',
    description: 'Complete 3 training tasks to unlock this badge.',
    progress: 0.9,
    reward: 'Gold paw',
    iconUrl: 'https://images.unsplash.com/photo-1504593811423-6dd665756598?auto=format&fit=crop&w=400&q=80',
    completed: true,
  ),
];
