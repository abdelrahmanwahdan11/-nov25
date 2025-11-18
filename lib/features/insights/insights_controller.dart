import 'dart:async';
import '../../data/mock/mock_insights.dart';
import '../../data/models/insight_metric.dart';

class InsightsController {
  final _stream = StreamController<List<InsightMetric>>.broadcast();
  bool isLoading = false;
  List<InsightMetric> _metrics = [];

  Stream<List<InsightMetric>> get metricsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_metrics);
    await Future.delayed(const Duration(milliseconds: 650));
    _metrics = List.from(mockInsightMetrics);
    isLoading = false;
    _stream.add(_metrics);
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 400));
    await load();
  }

  void nudge(String id, double delta) {
    _metrics = _metrics
        .map((m) => m.id == id
            ? m.copyWith(progress: (m.progress + delta).clamp(0.0, 1.0))
            : m)
        .toList();
    _stream.add(_metrics);
  }

  void dispose() {
    _stream.close();
  }
}
