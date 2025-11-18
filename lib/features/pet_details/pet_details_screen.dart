import 'package:flutter/material.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import '../home/home_discover_screen.dart';

class PetDetailsScreen extends StatelessWidget {
  final PetDetailsArgs args;
  const PetDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final pet = args.pet;
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
                            _circleInfo('${pet.ageYears}y', 'Age'),
                            const SizedBox(width: 12),
                            _circleInfo('${pet.weightKg}kg', 'Weight'),
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
                            onPressed: () {},
                            child: const Text('AI info'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Adopt'),
                                  content: const Text('Thanks for your interest! (mock dialog)'),
                                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                                ),
                              );
                            },
                            child: const Text('Adopt'),
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
