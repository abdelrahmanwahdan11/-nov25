import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_achievement.dart';
import 'achievements_controller.dart';

class AchievementsScreen extends StatefulWidget {
  final AchievementsController controller;
  const AchievementsScreen({super.key, required this.controller});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('achievements')),
        actions: [
          IconButton(
            onPressed: () => widget.controller.load(),
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: StreamBuilder<List<PetAchievement>>(
        stream: widget.controller.achievementsStream,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          if (widget.controller.isLoading && list.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Skeleton(height: 120, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => widget.controller.load(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  t('achievements_subtitle'),
                  style: Theme.of(context).textTheme.titleMedium,
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 12),
                ...list.map((a) => _AchievementCard(
                      achievement: a,
                      onNudge: () => widget.controller.nudgeProgress(a, 0.1),
                      onComplete: () => widget.controller.markComplete(a),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final PetAchievement achievement;
  final VoidCallback onNudge;
  final VoidCallback onComplete;
  const _AchievementCard({required this.achievement, required this.onNudge, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              achievement.iconUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (achievement.completed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          t('completed'),
                          style: TextStyle(color: color, fontWeight: FontWeight.w600),
                        ),
                      ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(achievement.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: achievement.progress,
                    minHeight: 10,
                    backgroundColor: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ).animate().shimmer(duration: 1200.ms),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${(achievement.progress * 100).round()}%', style: Theme.of(context).textTheme.labelMedium),
                    const Spacer(),
                    Text(t('reward_label', args: [achievement.reward]), style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onNudge,
                      icon: const Icon(Icons.bolt_rounded),
                      label: Text(t('boost')),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: onComplete,
                      child: Text(t('claim')),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(duration: 400.ms);
  }
}
