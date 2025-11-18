import '../models/timeline_event.dart';

final mockTimelineEvents = [
  TimelineEvent(
    id: 'tl1',
    petName: 'Luna',
    title: 'Evening walk',
    description: '40 min along the park trail with plenty of water breaks.',
    dateTime: DateTime.now().subtract(const Duration(hours: 3)),
    category: 'activity',
    accent: '#FF9E80',
  ),
  TimelineEvent(
    id: 'tl2',
    petName: 'Milo',
    title: 'Training milestone',
    description: 'Completed impulse control routine twice without treats.',
    dateTime: DateTime.now().subtract(const Duration(hours: 12)),
    category: 'training',
    accent: '#80CBC4',
  ),
  TimelineEvent(
    id: 'tl3',
    petName: 'Bella',
    title: 'Grooming booked',
    description: 'Scheduled a nail trim and bath at Paw Spa.',
    dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    category: 'care',
    accent: '#B39DDB',
  ),
  TimelineEvent(
    id: 'tl4',
    petName: 'Luna',
    title: 'Journal update',
    description: 'Logged a playful mood and new tug toy discovery.',
    dateTime: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    category: 'journal',
    accent: '#F48FB1',
  ),
];
