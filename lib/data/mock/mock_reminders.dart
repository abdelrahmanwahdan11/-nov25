import '../models/pet_reminder.dart';

const mockReminders = [
  PetReminder(
    id: 'rem1',
    title: 'Vaccination follow-up',
    timeLabel: 'Tomorrow · 9:00 AM',
    type: 'Health',
  ),
  PetReminder(
    id: 'rem2',
    title: 'Monthly grooming',
    timeLabel: 'Sat · 4:30 PM',
    type: 'Grooming',
  ),
  PetReminder(
    id: 'rem3',
    title: 'Evening walk & play',
    timeLabel: 'Daily · 7:00 PM',
    type: 'Activity',
  ),
];
