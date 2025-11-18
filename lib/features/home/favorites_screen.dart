import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import 'pet_controller.dart';
import 'home_discover_screen.dart';
import '../adoption/adoption_controller.dart';
import '../care/reminder_controller.dart';

class FavoritesScreen extends StatelessWidget {
  final PetController controller;
  final AdoptionController adoptionController;
  final ReminderController reminderController;
  const FavoritesScreen({
    super.key,
    required this.controller,
    required this.adoptionController,
    required this.reminderController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('favorites'))),
      body: RefreshIndicator(
        onRefresh: controller.refreshPets,
        child: StreamBuilder<List<Pet>>(
          stream: controller.favoritesStream,
          builder: (context, snapshot) {
            if (controller.isLoading) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Skeleton(height: 120, width: double.infinity),
                ),
              );
            }
            final favorites = snapshot.data ?? [];
            if (favorites.isEmpty) return Center(child: Text(t('empty_favorites')));
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (_, i) {
                final pet = favorites[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: Hero(
                    tag: pet.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(pet.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${pet.breed} · ${pet.ageYears}y'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => controller.toggleFavorite(pet),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/pet/details',
                    arguments: PetDetailsArgs(
                      pet,
                      adoptionController: adoptionController,
                      reminderController: reminderController,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
