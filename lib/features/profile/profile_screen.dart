import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/pet.dart';
import '../../data/models/pet_service.dart';
import '../home/pet_controller.dart';
import '../services/service_controller.dart';
import '../settings/settings_screen.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/localization/locale_controller.dart';

class ProfileScreen extends StatelessWidget {
  final PetController petController;
  final ServiceController serviceController;
  final ThemeController themeController;
  final LocaleController localeController;
  const ProfileScreen({
    super.key,
    required this.petController,
    required this.serviceController,
    required this.themeController,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('profile')),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 12))],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544723795-3fb6469f5b39'),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Guest Lover', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 4),
                    Text('guest@pawadopt.app'),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(t('your_pets')),
          SizedBox(
            height: 160,
            child: StreamBuilder<List<Pet>>(
              stream: petController.petsStream,
              builder: (context, snapshot) {
                final pets = snapshot.data ?? [];
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(pet.imageUrl, width: double.infinity, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(pet.name),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(t('pet_care_nearby')),
          StreamBuilder<List<PetService>>(
            stream: serviceController.servicesStream,
            builder: (context, snapshot) {
              final services = snapshot.data ?? [];
              return Column(
                children: services
                    .take(2)
                    .map((s) => ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(s.imageUrl)),
                          title: Text(s.name),
                          subtitle: Text('${s.distanceKm} km'),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  localeController: localeController,
                  themeController: themeController,
                ),
              ),
            ),
            child: Text(t('settings')),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      );
}
