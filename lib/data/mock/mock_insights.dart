import '../models/insight_metric.dart';

final mockInsightMetrics = [
  InsightMetric(
    id: 'insight1',
    title: 'Calm day score',
    description: 'Hydration, walks, and enrichment blended into one soft score.',
    progress: 0.76,
    target: 1.0,
    trend: '+6% week',
    highlight: true,
  ),
  InsightMetric(
    id: 'insight2',
    title: 'Activity balance',
    description: 'Balanced play vs. rest time based on your reminders.',
    progress: 0.64,
    target: 1.0,
    trend: '+2 tasks',
  ),
  InsightMetric(
    id: 'insight3',
    title: 'Health momentum',
    description: 'Vaccines, checkups, and microchip milestones completed.',
    progress: 0.82,
    target: 1.0,
    trend: 'on track',
  ),
];
