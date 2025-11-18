import '../models/daily_checkin.dart';

final mockDailyCheckins = [
  DailyCheckin(
    id: 'check-1',
    petName: 'Luna',
    title: 'Morning walk & sniff time',
    timeLabel: '07:30',
    mood: 'excited',
    note: 'Keep pace light, let her explore.',
    completed: false,
  ),
  DailyCheckin(
    id: 'check-2',
    petName: 'Milo',
    title: 'Brush coat + quick health scan',
    timeLabel: '11:00',
    mood: 'calm',
    note: 'Check paws and ears, reward after.',
    completed: true,
  ),
  DailyCheckin(
    id: 'check-3',
    petName: 'Luna',
    title: 'Training reps: stay & recall',
    timeLabel: '15:00',
    mood: 'focused',
    note: 'Short bursts with high value treats.',
    completed: false,
  ),
  DailyCheckin(
    id: 'check-4',
    petName: 'Milo',
    title: 'Evening cuddle + paw balm',
    timeLabel: '20:00',
    mood: 'sleepy',
    note: 'Massage paws and calm breathing.',
    completed: false,
  ),
];
