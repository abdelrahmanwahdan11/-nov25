import 'dart:async';
import '../../data/mock/mock_achievements.dart';
import '../../data/models/pet_achievement.dart';

class AchievementsController {
  final _stream = StreamController<List<PetAchievement>>.broadcast();
  bool isLoading = false;
  List<PetAchievement> _achievements = [];

  Stream<List<PetAchievement>> get achievementsStream => _stream.stream;

  Future<void> load() async {
    isLoading = true;
    _stream.add(_achievements);
    await Future.delayed(const Duration(milliseconds: 600));
    _achievements = List.from(mockAchievements);
    isLoading = false;
    _stream.add(_achievements);
  }

  void nudgeProgress(PetAchievement achievement, double delta) {
    _achievements = _achievements.map((a) {
      if (a.id == achievement.id) {
        final nextProgress = (a.progress + delta).clamp(0.0, 1.0);
        final completed = nextProgress >= 0.99;
        return a.copyWith(progress: nextProgress, completed: completed);
      }
      return a;
    }).toList();
    _stream.add(_achievements);
  }

  void markComplete(PetAchievement achievement) {
    _achievements = _achievements.map((a) =>
        a.id == achievement.id ? a.copyWith(progress: 1.0, completed: true) : a).toList();
    _stream.add(_achievements);
  }

  void dispose() {
    _stream.close();
  }
}
