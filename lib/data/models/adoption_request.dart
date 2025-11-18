class AdoptionRequest {
  final String id;
  final String petId;
  final String petName;
  final String status;
  final String note;
  final DateTime submittedAt;

  const AdoptionRequest({
    required this.id,
    required this.petId,
    required this.petName,
    required this.status,
    required this.note,
    required this.submittedAt,
  });

  AdoptionRequest copyWith({String? status, String? note}) {
    return AdoptionRequest(
      id: id,
      petId: petId,
      petName: petName,
      status: status ?? this.status,
      note: note ?? this.note,
      submittedAt: submittedAt,
    );
  }
}
