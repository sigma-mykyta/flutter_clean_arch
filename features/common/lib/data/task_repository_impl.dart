import 'package:common/domain/entities/task.dart';
import 'package:injectable/injectable.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks();
  double getTaskProgress(List<Task> tasks);
}

@singleton
class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<List<Task>> fetchTasks() async {
    return [
      Task(title: 'Design Dashboard UI', isCompleted: true, dueDate: DateTime.now().subtract(Duration(days: 1))),
      Task(title: 'Implement Task List', isCompleted: false, dueDate: DateTime.now().add(Duration(days: 2))),
    ];
  }

  @override
  double getTaskProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }
}