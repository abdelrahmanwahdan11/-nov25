import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/care_tip.dart';
import 'care_tips_controller.dart';

class CareTipsScreen extends StatefulWidget {
  final CareTipsController controller;
  const CareTipsScreen({super.key, required this.controller});

  @override
  State<CareTipsScreen> createState() => _CareTipsScreenState();
}

class _CareTipsScreenState extends State<CareTipsScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('care_tips'))),
      body: RefreshIndicator(
        onRefresh: widget.controller.load,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChip(
                      label: Text(t('all')),
                      selected: widget.controller.filter == null,
                      onSelected: (_) => setState(() => widget.controller.filterByCategory(null)),
                    ),
                    const SizedBox(width: 10),
                    ...['Wellness', 'Grooming', 'Health', 'Training'].map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FilterChip(
                          label: Text(c),
                          selected: widget.controller.filter == c,
                          onSelected: (_) => setState(() => widget.controller.filterByCategory(c)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<CareTip>>(
                stream: widget.controller.tipsStream,
                builder: (context, snapshot) {
                  if (widget.controller.isLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Skeleton(height: 140, width: double.infinity),
                      ),
                    );
                  }
                  final tips = snapshot.data ?? [];
                  if (tips.isEmpty) {
                    return Center(child: Text(t('empty_tips')));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tips.length,
                    itemBuilder: (_, i) {
                      final tip = tips[i];
                      return _TipCard(
                        tip: tip,
                        onToggle: () => setState(() => widget.controller.toggleComplete(tip)),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final CareTip tip;
  final VoidCallback onToggle;
  const _TipCard({required this.tip, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
            child: Image.network(
              tip.imageUrl,
              width: 110,
              height: 140,
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn(duration: 300.ms),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: tip.categoryColor(theme.primaryColor),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(tip.category, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onToggle,
                        icon: Icon(
                          tip.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                          color: tip.isCompleted ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(tip.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${tip.durationMinutes} min · ${tip.description}', maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          )
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 320.ms);
  }
}
