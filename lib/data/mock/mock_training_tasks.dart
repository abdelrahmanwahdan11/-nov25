import '../models/training_task.dart';

final mockTrainingTasks = [
  TrainingTask(
    id: 'tt1',
    title: 'Loose-leash walking',
    level: 'Beginner',
    petName: 'Luna',
    progress: 0.35,
    steps: [
      'Reward next to your left leg',
      'Increase distance in hallway',
      'Practice 5 minutes outdoors',
    ],
  ),
  TrainingTask(
    id: 'tt2',
    title: 'Recall on cue',
    level: 'Intermediate',
    petName: 'Milo',
    progress: 0.6,
    steps: [
      'Name game with treats',
      'Add light distractions',
      'Try in park with long leash',
    ],
  ),
  TrainingTask(
    id: 'tt3',
    title: 'Crate comfort',
    level: 'Beginner',
    petName: 'Luna',
    progress: 0.8,
    steps: [
      'Feed meals inside crate',
      'Short naps with door open',
      'Increase closed-door time',
    ],
    completed: false,
  ),
];
