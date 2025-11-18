import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock/mock_notifications.dart';
import '../../data/models/app_notification.dart';

class NotificationController extends ChangeNotifier {
  final _stream = StreamController<List<AppNotification>>.broadcast();
  List<AppNotification> _items = [];
  bool isLoading = false;

  Stream<List<AppNotification>> get notificationsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _push();
    await Future.delayed(const Duration(milliseconds: 700));
    _items = List.from(mockNotifications);
    isLoading = false;
    _push();
  }

  Future<void> refresh() async => load();

  void markRead(AppNotification item) {
    _items = _items.map((n) => n.id == item.id ? n.copyWith(isRead: true) : n).toList();
    _push();
  }

  void markAllRead() {
    _items = _items.map((n) => n.copyWith(isRead: true)).toList();
    _push();
  }

  void addNotification(AppNotification item) {
    _items = [item, ..._items];
    _push();
  }

  void _push() {
    _stream.add(List.unmodifiable(_items));
    notifyListeners();
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
