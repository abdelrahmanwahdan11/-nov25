import 'dart:async';
import '../../data/mock/mock_health_records.dart';
import '../../data/models/health_record.dart';

class HealthController {
  final _recordsStream = StreamController<List<HealthRecord>>.broadcast();
  bool isLoading = false;
  List<HealthRecord> _records = [];

  Stream<List<HealthRecord>> get recordsStream => _recordsStream.stream;

  Future<void> load() async {
    isLoading = true;
    _recordsStream.add(_records);
    await Future.delayed(const Duration(milliseconds: 700));
    _records = List.from(mockHealthRecords);
    isLoading = false;
    _recordsStream.add(_records);
  }

  void toggleComplete(HealthRecord record) {
    _records = _records
        .map((r) => r.id == record.id ? r.copyWith(completed: !r.completed) : r)
        .toList();
    _recordsStream.add(_records);
  }

  void addQuickRecord(HealthRecord record) {
    _records = [record, ..._records];
    _recordsStream.add(_records);
  }

  void dispose() {
    _recordsStream.close();
  }
}
