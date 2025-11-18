import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/emergency_guide.dart';
import 'emergency_controller.dart';

class EmergencyScreen extends StatefulWidget {
  final EmergencyController controller;
  const EmergencyScreen({super.key, required this.controller});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('emergency_ready')),
        actions: [IconButton(onPressed: widget.controller.load, icon: const Icon(Icons.refresh_rounded))],
      ),
      body: StreamBuilder<List<EmergencyGuide>>(
        stream: widget.controller.guidesStream,
        builder: (context, snapshot) {
          final guides = snapshot.data ?? [];
          if (widget.controller.isLoading && guides.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Skeleton(height: 140, width: double.infinity),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(t('emergency_description'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...guides.map((g) => _EmergencyCard(guide: g)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final EmergencyGuide guide;
  const _EmergencyCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final t = AppLocalizations.of(context).t;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 10))],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.16), shape: BoxShape.circle),
                child: const Icon(Icons.health_and_safety_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guide.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(guide.description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: guide.steps
                .map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
                      backgroundColor: color.withOpacity(0.14),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bolt_rounded),
                label: Text(t('open_guide')),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: Text(guide.hotline),
              )
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 380.ms).scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));
  }
}
