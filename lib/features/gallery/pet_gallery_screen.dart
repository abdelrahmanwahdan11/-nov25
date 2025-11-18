import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_moment.dart';
import 'gallery_controller.dart';

class PetGalleryScreen extends StatelessWidget {
  final GalleryController controller;
  const PetGalleryScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('gallery'))),
      body: StreamBuilder<List<PetMoment>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          final moments = snapshot.data ?? [];
          if (controller.isLoading && moments.isEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => const Skeleton(height: 160, width: double.infinity),
            );
          }
          return RefreshIndicator(
            onRefresh: () => controller.load(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: moments.length,
              itemBuilder: (_, i) {
                final moment = moments[i];
                return _MomentCard(
                  moment: moment,
                  onLike: () => controller.like(moment),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  final PetMoment moment;
  final VoidCallback onLike;
  const _MomentCard({required this.moment, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(moment.imageUrl, height: 260, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(moment.petName, style: Theme.of(context).textTheme.titleMedium),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.favorite, size: 18, color: Colors.pinkAccent),
                            const SizedBox(width: 4),
                            Text(moment.likes.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(moment.caption, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              )
            ],
          ),
        ).animate().scale(duration: 280.ms, curve: Curves.easeOutBack),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(moment.imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(moment.petName, style: Theme.of(context).textTheme.titleMedium),
                      ),
                      IconButton(
                        onPressed: onLike,
                        icon: const Icon(Icons.favorite_outline),
                        color: color,
                      )
                    ],
                  ),
                  Text(moment.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 16, color: Colors.pinkAccent),
                      const SizedBox(width: 4),
                      Text(moment.likes.toString()),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 420.ms),
    );
  }
}
