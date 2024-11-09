import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/data/task_repository_impl.dart';
import 'package:common/domain/entities/task.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final TaskRepository taskRepository;

  TaskDetailsBloc({required this.taskRepository}) : super(TaskDetailsInitial()) {
    // Register the event handler
    on<MarkTaskCompleteEvent>(_onMarkTaskComplete);
    on<EditTaskEvent>(_onEditTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onMarkTaskComplete(
    MarkTaskCompleteEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(TaskDetailsLoading());
    
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
      );
      
      // Update in repository
      await taskRepository.updateTask(updatedTask);
      
      emit(TaskDetailsUpdated(updatedTask));
    } catch (e) {
      emit(TaskDetailsError('Failed to mark task as complete.'));
    }
  }

  Future<void> _onEditTask(
    EditTaskEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(TaskDetailsLoading());
    
    try {
      // Update task in repository
      await taskRepository.updateTask(event.task);
      
      emit(TaskDetailsUpdated(event.task));
    } catch (e) {
      emit(TaskDetailsError('Failed to edit task.'));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(TaskDetailsLoading());
    
    try {
      // Delete task from repository
      await taskRepository.deleteTask(event.taskId);
      
      emit(TaskDetailsDeleted());
    } catch (e) {
      emit(TaskDetailsError('Failed to delete task.'));
    }
  }
}