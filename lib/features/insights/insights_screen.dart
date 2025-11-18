import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/insight_metric.dart';
import 'insights_controller.dart';

class InsightsScreen extends StatelessWidget {
  final InsightsController controller;
  const InsightsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('insights'))),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: StreamBuilder<List<InsightMetric>>(
          stream: controller.metricsStream,
          builder: (context, snapshot) {
            if (controller.isLoading) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Skeleton(height: 120, width: double.infinity),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: 4,
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(child: Text(t('empty_insights')));
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(t('wellness_overview'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...items.map(
                  (m) => _InsightCard(
                    metric: m,
                    onBoost: () => controller.nudge(m.id, 0.04),
                    t: t,
                  ).animate(delay: (items.indexOf(m) * 80).ms).fadeIn().slide(begin: const Offset(0, 0.05)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final InsightMetric metric;
  final VoidCallback onBoost;
  final String Function(String) t;
  const _InsightCard({required this.metric, required this.onBoost, required this.t});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: metric.highlight ? theme.primaryColor.withOpacity(0.08) : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          _ProgressDonut(progress: metric.progress),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metric.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(metric.description),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${(metric.progress * 100).round()}% ${t('progress')}'),
                    ),
                    const SizedBox(width: 8),
                    Text(metric.trend, style: TextStyle(color: theme.colorScheme.secondary)),
                  ],
                )
              ],
            ),
          ),
          IconButton(onPressed: onBoost, icon: const Icon(Icons.bolt_rounded))
        ],
      ),
    );
  }
}

class _ProgressDonut extends StatelessWidget {
  final double progress;
  const _ProgressDonut({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: 600.ms,
            curve: Curves.easeOut,
            builder: (_, value, __) => CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              backgroundColor: theme.primaryColor.withOpacity(0.14),
              valueColor: AlwaysStoppedAnimation(theme.primaryColor),
            ),
          ),
          Text('${(progress * 100).round()}%'),
        ],
      ),
    );
  }
}
