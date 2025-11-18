import 'dart:async';
import '../../data/mock/mock_timeline.dart';
import '../../data/models/timeline_event.dart';

class TimelineController {
  final _stream = StreamController<List<TimelineEvent>>.broadcast();
  bool isLoading = false;
  List<TimelineEvent> _events = [];

  Stream<List<TimelineEvent>> get stream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_events);
    await Future.delayed(const Duration(milliseconds: 650));
    _events = List.from(mockTimelineEvents)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    isLoading = false;
    _stream.add(_events);
  }

  void addEvent(TimelineEvent event) {
    _events = [event, ..._events];
    _stream.add(_events);
  }

  void dispose() {
    _stream.close();
  }
}
