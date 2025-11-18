import '../models/app_notification.dart';

final mockNotifications = [
  AppNotification(
    id: 'n1',
    title: 'Vaccination reminder',
    body: 'Luna is due for annual shots this week.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.reminder,
    route: '/care/health',
  ),
  AppNotification(
    id: 'n2',
    title: 'Training streak',
    body: 'Rocky completed 3 training tasks in a row.',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    type: NotificationType.training,
    route: '/training',
  ),
  AppNotification(
    id: 'n3',
    title: 'Adoption request updated',
    body: 'Your request for Coco is now being reviewed.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.adoption,
    route: '/adoption/requests',
  ),
  AppNotification(
    id: 'n4',
    title: 'Service nearby',
    body: 'Happy Paws Spa has a new grooming slot tomorrow.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    type: NotificationType.service,
    route: '/services',
  ),
  AppNotification(
    id: 'n5',
    title: 'Journal',
    body: 'Remember to log Bella\'s new trick today.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    type: NotificationType.journal,
    route: '/journal',
  ),
];
