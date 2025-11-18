import '../models/emergency_guide.dart';

final mockEmergencyGuides = [
  EmergencyGuide(
    id: 'eg1',
    title: 'Heat safety',
    description: 'Checklist to keep pets cool during summer walks.',
    steps: [
      'Walk before 9 AM or after sunset.',
      'Check asphalt with back of your hand.',
      'Carry collapsible water bowl.',
      'Watch for panting and slow pace.',
    ],
    hotline: '+1 800 555 0120',
  ),
  EmergencyGuide(
    id: 'eg2',
    title: 'First aid basics',
    description: 'Quick actions before reaching the vet.',
    steps: [
      'Stay calm and secure your pet.',
      'Stop visible bleeding with clean cloth.',
      'Avoid giving human medicine.',
      'Head to nearest vet and call ahead.',
    ],
    hotline: '+1 800 555 0144',
  ),
];
