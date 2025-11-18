import 'package:flutter/material.dart';
import '../../core/widgets/skeleton.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/pet.dart';
import '../home/home_discover_screen.dart';
import '../adoption/adoption_controller.dart';
import '../care/reminder_controller.dart';
import '../../data/models/pet_reminder.dart';

class PetDetailsScreen extends StatelessWidget {
  final PetDetailsArgs args;
  const PetDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final pet = args.pet;
    final adoption = args.adoptionController;
    final reminderController = args.reminderController;
    final noteController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: pet.id,
            child: Image.network(
              pet.imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Skeleton(height: 320, width: double.infinity),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.52,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                            Text('${pet.breed} · ${pet.gender}')
                          ],
                        ),
                        Row(
                          children: [
                            _circleInfo('${pet.ageYears}y', t('age')),
                            const SizedBox(width: 12),
                            _circleInfo('${pet.weightKg}kg', t('weight')),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(pet.longDescription, style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(t('ai_info')),
                                  content: Text(t('ai_placeholder')),
                                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t('close')))],
                                ),
                              );
                            },
                            child: Text(t('ai_info')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(t('adopt')),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${t('adoption_note_for')} ${pet.name}'),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: noteController,
                                        decoration: InputDecoration(hintText: t('note_optional')),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text(t('cancel'))),
                                    ElevatedButton(
                                      onPressed: () {
                                        adoption?.submitRequest(pet, note: noteController.text);
                                        reminderController?.addReminder(PetReminder(
                                          id: DateTime.now().toString(),
                                          title: 'Meet ${pet.name}',
                                          timeLabel: 'This week',
                                          type: 'Adoption',
                                        ));
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(t('request_submitted'))),
                                        );
                                      },
                                      child: Text(t('submit')),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(t('adopt')),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _circleInfo(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF2C3A5),
          ),
          child: Text(value),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
