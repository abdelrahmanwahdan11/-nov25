import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import 'pet_controller.dart';
import '../adoption/adoption_controller.dart';
import '../care/reminder_controller.dart';
import '../notifications/notification_controller.dart';
import '../journal/journal_controller.dart';
import '../../data/models/pet_journal_entry.dart';
import '../../data/models/app_notification.dart';

class HomeDiscoverScreen extends StatefulWidget {
  final PetController petController;
  final AdoptionController adoptionController;
  final ReminderController reminderController;
  final NotificationController notificationController;
  final JournalController journalController;
  const HomeDiscoverScreen({
    super.key,
    required this.petController,
    required this.adoptionController,
    required this.reminderController,
    required this.notificationController,
    required this.journalController,
  });

  @override
  State<HomeDiscoverScreen> createState() => _HomeDiscoverScreenState();
}

class _HomeDiscoverScreenState extends State<HomeDiscoverScreen> {
  final _pageController = PageController(viewportFraction: 0.82);
  PetType? selectedType;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: widget.petController.refreshPets,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('discover_title'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(t('discover_subtitle'), style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none_rounded),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: StreamBuilder<List<AppNotification>>(
                                stream: widget.notificationController.notificationsStream,
                                builder: (context, snapshot) {
                                  final hasUnread = (snapshot.data ?? []).any((n) => !n.isRead);
                                  if (!hasUnread) return const SizedBox.shrink();
                                  return Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/pet/compare'),
                        icon: const Icon(Icons.filter_alt_outlined),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(t('all')),
                        selected: selectedType == null,
                        onSelected: (_) {
                          setState(() => selectedType = null);
                          widget.petController.refreshPets();
                        },
                      ),
                    ),
                    ...PetType.values
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                selectedColor: Theme.of(context).primaryColor,
                                label: Text(e.name),
                                selected: selectedType == e,
                                onSelected: (_) {
                                  setState(() => selectedType = e);
                                  widget.petController.filterByType(e);
                                },
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _journalPeek(context, t),
              const SizedBox(height: 16),
              SizedBox(
                height: 380,
                child: StreamBuilder<List<Pet>>(
                  stream: widget.petController.petsStream,
                  builder: (context, snapshot) {
                    if (widget.petController.isLoading) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Skeleton(height: 360, width: 280),
                        ),
                      );
                    }
                    final pets = snapshot.data ?? [];
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: pets.length,
                      itemBuilder: (_, i) {
                        final pet = pets[i];
                        return _PetCard(pet: pet, onTap: () => _openDetails(pet)).animate().scale(begin: const Offset(0.95, 0.95));
                      },
                      onPageChanged: (i) {
                        if (i >= pets.length - 1) {
                          widget.petController.loadMorePets();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                icon: const Icon(Icons.pets),
                label: Text(t('see_more')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _journalPeek(BuildContext context, String Function(String) t) {
    return StreamBuilder<List<PetJournalEntry>>(
      stream: widget.journalController.entriesStream,
      builder: (context, snapshot) {
        if (widget.journalController.isLoading) {
          return const Skeleton(height: 120, width: double.infinity);
        }
        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return _JournalCardPlaceholder(t: t, onTap: () => Navigator.pushNamed(context, '/journal'));
        }
        final latest = entries.first;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/journal'),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 10))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.book_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('journal'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${latest.petName} · ${latest.title}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(latest.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded)
              ],
            ),
          ).animate().fadeIn().slide(begin: const Offset(0, 0.06)),
        );
      },
    );
  }

  void _openDetails(Pet pet) {
    Navigator.pushNamed(
      context,
      '/pet/details',
      arguments: PetDetailsArgs(
        pet,
        adoptionController: widget.adoptionController,
        reminderController: widget.reminderController,
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;
  const _PetCard({required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: Hero(
                  tag: pet.id,
                  child: Image.network(pet.imageUrl, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('${pet.breed} · ${pet.ageYears}y · ${pet.weightKg}kg'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _JournalCardPlaceholder extends StatelessWidget {
  final String Function(String) t;
  final VoidCallback onTap;
  const _JournalCardPlaceholder({required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.edit_note, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(t('empty_journal'))),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class PetDetailsArgs {
  final Pet pet;
  final AdoptionController? adoptionController;
  final ReminderController? reminderController;
  PetDetailsArgs(this.pet, {this.adoptionController, this.reminderController});
}
