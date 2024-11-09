import 'package:equatable/equatable.dart';
import 'package:common/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredAndSortedTasks;
  final String selectedFilter;
  final String selectedSortOption;

  const TaskLoaded({
    required this.tasks,
    required this.filteredAndSortedTasks,
    required this.selectedFilter,
    required this.selectedSortOption,
  });

  @override
  List<Object?> get props => [tasks, filteredAndSortedTasks, selectedFilter, selectedSortOption];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskSearched extends TaskState {
  final List<Task> searchedTasks;

  const TaskSearched(this.searchedTasks);

  @override
  List<Object?> get props => [searchedTasks];
}