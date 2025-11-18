class PetSupply {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final bool lowStock;
  final String imageUrl;
  final String note;

  PetSupply({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lowStock,
    required this.imageUrl,
    required this.note,
  });

  PetSupply copyWith({
    int? quantity,
    bool? lowStock,
  }) {
    return PetSupply(
      id: id,
      name: name,
      category: category,
      quantity: quantity ?? this.quantity,
      unit: unit,
      lowStock: lowStock ?? this.lowStock,
      imageUrl: imageUrl,
      note: note,
    );
  }
}
