import '../models/health_record.dart';

final mockHealthRecords = [
  HealthRecord(
    id: 'hr1',
    petName: 'Luna',
    type: 'Vaccine - Rabies',
    date: DateTime.now().add(const Duration(days: 4)),
    location: 'Happy Paws Vet',
    note: 'Bring previous vaccine card.',
  ),
  HealthRecord(
    id: 'hr2',
    petName: 'Milo',
    type: 'Vet follow-up',
    date: DateTime.now().add(const Duration(days: 9)),
    location: 'City Vet Clinic',
    note: 'Check healed stitches.',
  ),
  HealthRecord(
    id: 'hr3',
    petName: 'Luna',
    type: 'Weight check',
    date: DateTime.now().subtract(const Duration(days: 3)),
    location: 'Home scale',
    note: 'Gained 0.3kg since last month',
    completed: true,
  ),
];
