import 'package:equatable/equatable.dart';
import 'package:common/domain/entities/task.dart';

abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object?> get props => [];
}

class MarkTaskCompleteEvent extends TaskDetailsEvent {
  final Task task;

  const MarkTaskCompleteEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class EditTaskEvent extends TaskDetailsEvent {
  final Task task;

  const EditTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskDetailsEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}