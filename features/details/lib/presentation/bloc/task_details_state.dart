import 'package:equatable/equatable.dart';
import 'package:common/domain/entities/task.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object?> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}
class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsUpdated extends TaskDetailsState {
  final Task task;

  const TaskDetailsUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDetailsDeleted extends TaskDetailsState {}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}