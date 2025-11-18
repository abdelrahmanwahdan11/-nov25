import 'dart:async';
import '../../data/mock/mock_gallery.dart';
import '../../data/models/pet_moment.dart';

class GalleryController {
  final _stream = StreamController<List<PetMoment>>.broadcast();
  bool isLoading = false;
  List<PetMoment> _moments = [];

  Stream<List<PetMoment>> get stream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_moments);
    await Future.delayed(const Duration(milliseconds: 500));
    _moments = List.from(mockPetMoments);
    isLoading = false;
    _stream.add(_moments);
  }

  void like(PetMoment moment) {
    _moments = _moments.map((m) => m.id == moment.id ? m.copyWith(likes: m.likes + 1) : m).toList();
    _stream.add(_moments);
  }

  void dispose() {
    _stream.close();
  }
}
