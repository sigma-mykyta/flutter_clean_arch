import 'package:equatable/equatable.dart';
import 'package:common/domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasksEventList extends TaskEvent {}

class SetFilterEvent extends TaskEvent {
  final String filter;

  const SetFilterEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class SetSortOptionEvent extends TaskEvent {
  final String sortOption;

  const SetSortOptionEvent({required this.sortOption});

  @override
  List<Object?> get props => [sortOption];
}

class MarkTaskCompleteEvent extends TaskEvent {
  final Task task;

  const MarkTaskCompleteEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}