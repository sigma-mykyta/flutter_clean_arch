import 'package:common/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks();
  double getTaskProgress(List<Task> tasks);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task> createTask(Task task);
  Future<List<Task>> getTasksByDueDate({required DateTime date});
  Future<List<Task>> getOverdueTasks();
}

@singleton
class TaskRepositoryImpl implements TaskRepository {
  final List<Task> _tasks = [
      Task(id: "1", title: 'Design Dashboard UI', isCompleted: true, dueDate: DateTime.now().subtract(Duration(days: 1))),
      Task(id: "2", title: 'Implement Task List', isCompleted: false, dueDate: DateTime.now().add(Duration(days: 2))),
    ];
  @override
  Future<List<Task>> fetchTasks() async {
    await Future.delayed(Duration(milliseconds: 800));
    return _tasks;
  }

  @override
  double getTaskProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }
  @override
  Future<Task> createTask(Task task) async {
    await Future.delayed(Duration(milliseconds: 500));
    final newTask = task.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );
    _tasks.add(newTask);
    return newTask;
  }

  @override
  Future<void> updateTask(Task task) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(updatedAt: DateTime.now());
    } else {
      throw Exception('Task with ID ${task.id} not found');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks.removeAt(index);
    } else {
      throw Exception('Task with ID $taskId not found');
    }
  }
  @override
  Future<List<Task>> getOverdueTasks() async {
    await Future.delayed(Duration(milliseconds: 500));
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      return task.dueDate!.isBefore(now);
    }).toList();
  }
   @override
  Future<List<Task>> getTasksByDueDate({required DateTime date}) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return DateUtils.isSameDay(task.dueDate!, date);
    }).toList();
  }
}