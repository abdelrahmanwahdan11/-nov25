import 'package:flutter/material.dart';

enum NotificationType { reminder, adoption, training, service, journal }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  final String? route;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    this.route,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        type: type,
        route: route,
        isRead: isRead ?? this.isRead,
      );

  IconData get icon {
    switch (type) {
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.adoption:
        return Icons.assignment_turned_in_outlined;
      case NotificationType.training:
        return Icons.school_rounded;
      case NotificationType.service:
        return Icons.room_service_outlined;
      case NotificationType.journal:
        return Icons.bookmark_border;
    }
  }
}
