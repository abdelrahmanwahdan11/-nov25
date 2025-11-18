import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import '../../data/models/pet_reminder.dart';
import '../../data/models/pet_service.dart';
import '../care/care_tips_controller.dart';
import '../care/reminder_controller.dart';
import '../adoption/adoption_controller.dart';
import '../home/pet_controller.dart';
import '../services/service_controller.dart';

class DashboardScreen extends StatelessWidget {
  final PetController petController;
  final ReminderController reminderController;
  final CareTipsController careTipsController;
  final AdoptionController adoptionController;
  final ServiceController serviceController;
  const DashboardScreen({
    super.key,
    required this.petController,
    required this.reminderController,
    required this.careTipsController,
    required this.adoptionController,
    required this.serviceController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _greetingHeader(context, t),
          const SizedBox(height: 16),
          _sectionTitle(t('upcoming_reminders')),
          _ReminderStrip(controller: reminderController),
          const SizedBox(height: 16),
          _sectionTitle(t('latest_requests')),
          _AdoptionStrip(controller: adoptionController),
          const SizedBox(height: 16),
          _sectionTitle(t('care_highlights')),
          _CareTipsStrip(controller: careTipsController),
          const SizedBox(height: 16),
          _sectionTitle(t('favorites')),
          _FavoritesStrip(controller: petController),
          const SizedBox(height: 16),
          _sectionTitle(t('services')),
          _ServicesStrip(controller: serviceController),
        ],
      ),
    );
  }

  Widget _greetingHeader(BuildContext context, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 12))],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.15),
            ),
            child: const Icon(Icons.dashboard_customize_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('dashboard_greeting'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(t('care_plan')),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/my-pets'),
            child: Text(t('my_pets')),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      );
}

class _ReminderStrip extends StatelessWidget {
  final ReminderController controller;
  const _ReminderStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder<List<PetReminder>>(
        stream: controller.remindersStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 110, width: 200),
              ),
            );
          }
          final reminders = snapshot.data ?? [];
          if (reminders.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_reminders')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reminders.length,
            itemBuilder: (_, i) {
              final r = reminders[i];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(r.timeLabel),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => controller.toggleDone(r),
                        child: Text(AppLocalizations.of(context).t('mark_done')),
                      ),
                    )
                  ],
                ),
              ).animate().fadeIn();
            },
          );
        },
      ),
    );
  }
}

class _AdoptionStrip extends StatelessWidget {
  final AdoptionController controller;
  const _AdoptionStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: controller.requestsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 100, width: 220),
              ),
            );
          }
          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_requests')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: requests.length,
            itemBuilder: (_, i) {
              final r = requests[i];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.petName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${AppLocalizations.of(context).t('submitted_on')}: ${r.submittedAt.toLocal().toString().split(' ').first}'),
                    const Spacer(),
                    Text(r.status.toUpperCase(), style: TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              ).animate().slide(begin: const Offset(0.1, 0));
            },
          );
        },
      ),
    );
  }
}

class _CareTipsStrip extends StatelessWidget {
  final CareTipsController controller;
  const _CareTipsStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder(
        stream: controller.tipsStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Skeleton(height: 110, width: 180),
              ),
            );
          }
          final tips = snapshot.data ?? [];
          if (tips.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_tips')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tips.length,
            itemBuilder: (_, i) {
              final tip = tips[i];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Expanded(child: Text(tip.description, maxLines: 3, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms);
            },
          );
        },
      ),
    );
  }
}

class _FavoritesStrip extends StatelessWidget {
  final PetController controller;
  const _FavoritesStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: StreamBuilder<List<Pet>>(
        stream: controller.favoritesStream,
        builder: (context, snapshot) {
          final pets = snapshot.data ?? [];
          if (pets.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('empty_favorites')));
          }
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
                      child: Text(pet.name),
                    )
                  ],
                ),
              ).animate().scale(begin: const Offset(0.96, 0.96));
            },
          );
        },
      ),
    );
  }
}

class _ServicesStrip extends StatelessWidget {
  final ServiceController controller;
  const _ServicesStrip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: StreamBuilder<List<PetService>>(
        stream: controller.servicesStream,
        builder: (context, snapshot) {
          if (controller.isLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Skeleton(height: 120, width: 200),
              ),
            );
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context).t('pet_care_nearby')));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (_, i) {
              final s = services[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/services/details', arguments: s),
                child: Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(s.imageUrl), radius: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${s.distanceKm} km · ${s.rating}★'),
                          ],
                        ),
                      )
                    ],
                  ),
                ).animate().fadeIn(),
              );
            },
          );
        },
      ),
    );
  }
}
