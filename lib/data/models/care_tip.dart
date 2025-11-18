import 'package:flutter/material.dart';

class CareTip {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final int durationMinutes;
  final bool isCompleted;

  const CareTip({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.durationMinutes,
    this.isCompleted = false,
  });

  CareTip copyWith({bool? isCompleted}) {
    return CareTip(
      id: id,
      title: title,
      category: category,
      description: description,
      imageUrl: imageUrl,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Color categoryColor(Color seed) => seed.withOpacity(0.18);
}
