import 'package:flutter/material.dart';

class VetVisit {
  final String id;
  final String petName;
  final String clinicName;
  final DateTime dateTime;
  final String doctor;
  final String reason;
  final String status; // upcoming, completed, urgent
  final String note;
  final String imageUrl;

  const VetVisit({
    required this.id,
    required this.petName,
    required this.clinicName,
    required this.dateTime,
    required this.doctor,
    required this.reason,
    required this.status,
    required this.note,
    required this.imageUrl,
  });

  VetVisit copyWith({
    String? id,
    String? petName,
    String? clinicName,
    DateTime? dateTime,
    String? doctor,
    String? reason,
    String? status,
    String? note,
    String? imageUrl,
  }) {
    return VetVisit(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      clinicName: clinicName ?? this.clinicName,
      dateTime: dateTime ?? this.dateTime,
      doctor: doctor ?? this.doctor,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      note: note ?? this.note,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
