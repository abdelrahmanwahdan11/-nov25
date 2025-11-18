import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import '../home/pet_controller.dart';
import '../care/reminder_controller.dart';
import '../adoption/adoption_controller.dart';

class MyPetsScreen extends StatelessWidget {
  final PetController petController;
  final AdoptionController adoptionController;
  final ReminderController reminderController;
  const MyPetsScreen({
    super.key,
    required this.petController,
    required this.adoptionController,
    required this.reminderController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('my_pets'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(t('favorites')),
          SizedBox(
            height: 180,
            child: StreamBuilder<List<Pet>>(
              stream: petController.favoritesStream,
              builder: (context, snapshot) {
                final pets = snapshot.data ?? [];
                if (petController.isLoading) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Skeleton(height: 160, width: 160),
                    ),
                  );
                }
                if (pets.isEmpty) {
                  return Center(child: Text(t('empty_favorites')));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              child: Image.network(pet.imageUrl, fit: BoxFit.cover, width: double.infinity),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('${pet.breed} · ${pet.ageYears}y'),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _sectionTitle(t('adoption_status')),
          StreamBuilder(
            stream: adoptionController.requestsStream,
            builder: (context, snapshot) {
              final requests = snapshot.data ?? [];
              if (adoptionController.isLoading) {
                return const Skeleton(height: 120);
              }
              if (requests.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(t('empty_requests')),
                );
              }
              return Column(
                children: requests
                    .map(
                      (r) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        title: Text(r.petName),
                        subtitle: Text('${t('submitted_on')}: ${r.submittedAt.toLocal().toString().split(' ').first}'),
                        trailing: Text(r.status.toUpperCase(), style: TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 14),
          _sectionTitle(t('reminders')),
          StreamBuilder(
            stream: reminderController.remindersStream,
            builder: (context, snapshot) {
              final reminders = snapshot.data ?? [];
              if (reminderController.isLoading) {
                return const Skeleton(height: 120);
              }
              if (reminders.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(t('empty_reminders')),
                );
              }
              return Column(
                children: reminders
                    .map(
                      (r) => ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(r.title),
                        subtitle: Text(r.timeLabel),
                        trailing: Checkbox(
                          value: r.isDone,
                          onChanged: (_) => reminderController.toggleDone(r),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
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
