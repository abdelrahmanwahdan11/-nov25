import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import 'pet_controller.dart';
import '../adoption/adoption_controller.dart';
import '../care/reminder_controller.dart';

class HomeDiscoverScreen extends StatefulWidget {
  final PetController petController;
  final AdoptionController adoptionController;
  final ReminderController reminderController;
  const HomeDiscoverScreen({
    super.key,
    required this.petController,
    required this.adoptionController,
    required this.reminderController,
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
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/pet/compare'),
                    icon: const Icon(Icons.filter_alt_outlined),
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
                onPressed: () => Navigator.pushNamed(context, '/home'),
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

class PetDetailsArgs {
  final Pet pet;
  final AdoptionController? adoptionController;
  final ReminderController? reminderController;
  PetDetailsArgs(this.pet, {this.adoptionController, this.reminderController});
}
