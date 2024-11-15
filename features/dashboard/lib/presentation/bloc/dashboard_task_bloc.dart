import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:common/data/task_repository_impl.dart';
import 'package:common/domain/entities/task.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardTaskEvent extends Equatable {
  const DashboardTaskEvent();
  
  @override
  List<Object> get props => [];
}

class FetchTasksEvent extends DashboardTaskEvent {}

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

//states
class TaskInitial extends TaskState {}
class TaskLoading extends TaskState {}
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final double progress;

  const TaskLoaded({required this.tasks, required this.progress});

  @override
  List<Object> get props => [tasks, progress];
}
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}

@injectable
class DashboardTaskBloc extends Bloc<DashboardTaskEvent, TaskState> {
  final TaskRepository taskRepository;

  DashboardTaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      emit(TaskLoading());

      try {
        final tasks = await taskRepository.fetchTasks();
        final progress = taskRepository.getTaskProgress(tasks);
        emit(TaskLoaded(tasks: tasks, progress: progress));
      } catch (e) {
        emit(TaskError('Failed to load tasks'));
      }
    });
  }
}