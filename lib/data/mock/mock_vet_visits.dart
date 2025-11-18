import 'package:flutter/material.dart';
import '../models/vet_visit.dart';

final mockVetVisits = [
  VetVisit(
    id: 'vv1',
    petName: 'Luna',
    clinicName: 'Peach Grove Vet',
    dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    doctor: 'Dr. Noor',
    reason: 'Annual vaccines + wellness',
    status: 'upcoming',
    note: 'Bring previous records and favorite toy for calm.',
    imageUrl: 'https://images.unsplash.com/photo-1559070154-582a0a0d4a4b',
  ),
  VetVisit(
    id: 'vv2',
    petName: 'Milo',
    clinicName: 'Happy Paws Clinic',
    dateTime: DateTime.now().add(const Duration(days: 3, hours: -1)),
    doctor: 'Dr. Rami',
    reason: 'Dental cleaning follow-up',
    status: 'upcoming',
    note: 'Check gum redness and adjust diet.',
    imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a',
  ),
  VetVisit(
    id: 'vv3',
    petName: 'Bella',
    clinicName: '24/7 Care Center',
    dateTime: DateTime.now().add(const Duration(hours: -5)),
    doctor: 'Dr. June',
    reason: 'Stomach sensitivity review',
    status: 'completed',
    note: 'Prescribed lighter kibble, monitor hydration.',
    imageUrl: 'https://images.unsplash.com/photo-1537151625747-768eb6cf92b6',
  ),
];
