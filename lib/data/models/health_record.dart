import 'package:flutter/material.dart';

class HealthRecord {
  final String id;
  final String petName;
  final String type; // vaccine, vet, weight
  final DateTime date;
  final String location;
  final String note;
  final bool completed;

  const HealthRecord({
    required this.id,
    required this.petName,
    required this.type,
    required this.date,
    required this.location,
    this.note = '',
    this.completed = false,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  HealthRecord copyWith({bool? completed}) {
    return HealthRecord(
      id: id,
      petName: petName,
      type: type,
      date: date,
      location: location,
      note: note,
      completed: completed ?? this.completed,
    );
  }

  Color badgeColor(Color seed) => seed.withOpacity(0.16);
}
