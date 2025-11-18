import 'dart:async';
import '../../data/mock/mock_events.dart';
import '../../data/models/community_event.dart';

class CommunityController {
  final _stream = StreamController<List<CommunityEvent>>.broadcast();
  bool isLoading = false;
  List<CommunityEvent> _events = [];

  Stream<List<CommunityEvent>> get eventsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_events);
    await Future.delayed(const Duration(milliseconds: 650));
    _events = List.from(mockCommunityEvents);
    isLoading = false;
    _stream.add(_events);
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 400));
    await load();
  }

  void toggleSaved(CommunityEvent event) {
    _events = _events
        .map((e) => e.id == event.id ? e.copyWith(saved: !e.saved) : e)
        .toList();
    _stream.add(_events);
  }

  void dispose() {
    _stream.close();
  }
}
