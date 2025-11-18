import 'dart:async';
import '../../data/mock/mock_daily_checkins.dart';
import '../../data/models/daily_checkin.dart';

class DailyCheckinController {
  final _stream = StreamController<List<DailyCheckin>>.broadcast();
  bool isLoading = false;
  List<DailyCheckin> _items = [];

  Stream<List<DailyCheckin>> get itemsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_items);
    await Future.delayed(const Duration(milliseconds: 650));
    _items = List.from(mockDailyCheckins);
    isLoading = false;
    _stream.add(_items);
  }

  void toggleComplete(DailyCheckin item) {
    _items = _items.map((i) => i.id == item.id ? i.copyWith(completed: !i.completed) : i).toList();
    _stream.add(_items);
  }

  void addQuick(String title, String pet, String mood, String note) {
    final now = DateTime.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final newItem = DailyCheckin(
      id: 'check-${DateTime.now().millisecondsSinceEpoch}',
      petName: pet,
      title: title,
      timeLabel: formattedTime,
      mood: mood,
      note: note,
      completed: false,
    );
    _items = [newItem, ..._items];
    _stream.add(_items);
  }

  void dispose() {
    _stream.close();
  }
}
