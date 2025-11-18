import 'package:flutter/material.dart';

class MealPlanItem {
  final String id;
  final String petName;
  final String meal;
  final TimeOfDay time;
  final int calories;
  final bool isDone;
  final String note;

  const MealPlanItem({
    required this.id,
    required this.petName,
    required this.meal,
    required this.time,
    required this.calories,
    required this.isDone,
    required this.note,
  });

  MealPlanItem copyWith({
    String? id,
    String? petName,
    String? meal,
    TimeOfDay? time,
    int? calories,
    bool? isDone,
    String? note,
  }) {
    return MealPlanItem(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      meal: meal ?? this.meal,
      time: time ?? this.time,
      calories: calories ?? this.calories,
      isDone: isDone ?? this.isDone,
      note: note ?? this.note,
    );
  }
}
