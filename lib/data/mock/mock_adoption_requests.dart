import '../models/adoption_request.dart';

final mockAdoptionRequests = <AdoptionRequest>[
  AdoptionRequest(
    id: 'req1',
    petId: 'pet1',
    petName: 'Luna',
    status: 'pending',
    note: 'Submitted from discover spotlight',
    submittedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
