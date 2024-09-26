import 'package:common/data/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:common/domain/entities/task.dart';
import '/data/task_repository.dart';
import 'package:get_it/get_it.dart';

class TaskListProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredAndSortedTasks = [];
  String _selectedFilter = 'All';
  String _selectedSortOption = 'Due Date';

  final TaskRepository taskRepository = GetIt.I<TaskRepository>();

  List<Task> get filteredAndSortedTasks => _filteredAndSortedTasks;
  String get selectedFilter => _selectedFilter;
  String get selectedSortOption => _selectedSortOption;

  Future<void> fetchTasks() async {
    if (_tasks.isEmpty) {
      _tasks = await taskRepository.fetchTasks();
      _applyFilterAndSort();
    }
    return Future.value();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilterAndSort();
  }

  void setSortOption(String sortOption) {
    _selectedSortOption = sortOption;
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    _filteredAndSortedTasks = _tasks.where((task) {
      if (_selectedFilter == 'Completed') return task.isCompleted;
      if (_selectedFilter == 'Pending') return !task.isCompleted;
      return true;
    }).toList();

    if (_selectedSortOption == 'Due Date') {
      _filteredAndSortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_selectedSortOption == 'Alphabetical') {
      _filteredAndSortedTasks.sort((a, b) => a.title.compareTo(b.title));
    }

    notifyListeners();
  }

  List<Task> searchTasks(String query) {
    return _tasks.where((task) => task.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}