import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/pet_service.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as PetService?;
    final t = AppLocalizations.of(context).t;
    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t('service_details'))),
        body: Center(child: Text(t('services'))),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(service.imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text('${t('distance')}: ${service.distanceKm} km'),
          const SizedBox(height: 6),
          Text('${t('rating_label')}: ${service.rating} ★'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.services
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.14),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(service.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('added_to_plan'))));
            },
            icon: const Icon(Icons.event_available),
            label: Text(t('book_service')),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          )
        ],
      ),
    );
  }
}
