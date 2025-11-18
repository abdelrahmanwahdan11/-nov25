import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_service.dart';
import 'service_controller.dart';

class PetCareNearbyScreen extends StatelessWidget {
  final ServiceController serviceController;
  const PetCareNearbyScreen({super.key, required this.serviceController});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('pet_care_nearby'))),
      body: RefreshIndicator(
        onRefresh: serviceController.refreshServices,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<PetService>>(
              stream: serviceController.servicesStream,
              builder: (context, snapshot) {
                if (serviceController.isLoading) {
                  return Column(
                    children: List.generate(
                      3,
                      (i) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Skeleton(height: 120, width: double.infinity),
                      ),
                    ),
                  );
                }
                final services = snapshot.data ?? [];
                return Column(
                  children: services
                      .map(
                        (s) => Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(s.imageUrl)),
                            title: Text(s.name),
                            subtitle: Text('${s.distanceKm}km • ${s.rating}⭐\n${s.services.join(', ')}'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
