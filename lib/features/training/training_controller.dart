import 'dart:async';
import '../../data/mock/mock_training_tasks.dart';
import '../../data/models/training_task.dart';

class TrainingController {
  final _tasksStream = StreamController<List<TrainingTask>>.broadcast();
  bool isLoading = false;
  List<TrainingTask> _tasks = [];

  Stream<List<TrainingTask>> get tasksStream => _tasksStream.stream;

  Future<void> load() async {
    isLoading = true;
    _tasksStream.add(_tasks);
    await Future.delayed(const Duration(milliseconds: 600));
    _tasks = List.from(mockTrainingTasks);
    isLoading = false;
    _tasksStream.add(_tasks);
  }

  void markStepDone(TrainingTask task) {
    _tasks = _tasks.map((t) {
      if (t.id == task.id) {
        final newProgress = (t.progress + 0.2).clamp(0.0, 1.0);
        final completed = newProgress >= 0.99;
        return t.copyWith(progress: newProgress, completed: completed);
      }
      return t;
    }).toList();
    _tasksStream.add(_tasks);
  }

  void toggleComplete(TrainingTask task) {
    _tasks = _tasks.map((t) =>
        t.id == task.id ? t.copyWith(completed: !t.completed, progress: t.completed ? t.progress : 1.0) : t).toList();
    _tasksStream.add(_tasks);
  }

  void dispose() {
    _tasksStream.close();
  }
}
