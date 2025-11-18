import 'package:flutter/material.dart';

enum PetType { dog, cat, bird, fish }

typedef PetList = List<Pet>;

class Pet {
  final String id;
  final String name;
  final PetType type;
  final String breed;
  final int ageYears;
  final double weightKg;
  final String gender;
  final double distanceKm;
  final double rating;
  final bool isVaccinated;
  final String imageUrl;
  final String shortDescription;
  final String longDescription;
  bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.ageYears,
    required this.weightKg,
    required this.gender,
    required this.distanceKm,
    required this.rating,
    required this.isVaccinated,
    required this.imageUrl,
    required this.shortDescription,
    required this.longDescription,
    this.isFavorite = false,
  });

  Pet copyWith({bool? isFavorite}) => Pet(
        id: id,
        name: name,
        type: type,
        breed: breed,
        ageYears: ageYears,
        weightKg: weightKg,
        gender: gender,
        distanceKm: distanceKm,
        rating: rating,
        isVaccinated: isVaccinated,
        imageUrl: imageUrl,
        shortDescription: shortDescription,
        longDescription: longDescription,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  Color cardTint(Color primary) => primary.withOpacity(0.08);
}
