import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/pet.dart';
import '../home/pet_controller.dart';

class CompareScreen extends StatelessWidget {
  final PetController petController;
  const CompareScreen({super.key, required this.petController});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('compare'))),
      body: StreamBuilder<List<Pet>>(
        stream: petController.compareStream,
        initialData: petController.selectedForCompare,
        builder: (context, snapshot) {
          final pets = snapshot.data ?? [];
          if (pets.length < 2) {
            return Center(child: Text(t('compare_hint')));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pets
                      .map(
                        (p) => Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(p.imageUrl, width: 90, height: 90, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 6),
                            Text(p.name, style: Theme.of(context).textTheme.titleMedium),
                            IconButton(
                              onPressed: () => petController.selectForCompare(p),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                _buildRow('Type', pets.map((p) => p.type.name).toList()),
                _buildRow('Breed', pets.map((p) => p.breed).toList()),
                _buildRow('Age', pets.map((p) => '${p.ageYears}y').toList()),
                _buildRow('Weight', pets.map((p) => '${p.weightKg}kg').toList()),
                _buildRow('Rating', pets.map((p) => p.rating.toString()).toList()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          ...values.map((v) => Expanded(child: Text(v, textAlign: TextAlign.center))).toList(),
        ],
      ),
    );
  }
}
