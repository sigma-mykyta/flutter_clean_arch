import 'package:common/data/task_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/domain/entities/task.dart';
import 'task_event.dart';
import 'task_state.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoading()) {
     on<FetchTasksEventList>(_onFetchTasks);
    on<SetFilterEvent>(_onSetFilter);
    on<SetSortOptionEvent>(_onSetSortOption);
    on<MarkTaskCompleteEvent>(_onMarkTaskComplete);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<SearchTasksEvent>(_onSearchTasks);
  }

  // final TaskRepository taskRepository = GetIt.I<TaskRepository>();
  

  List<Task> _tasks = [];
  List<Task> _filteredAndSortedTasks = [];
  String _selectedFilter = 'All';
  String _selectedSortOption = 'Due Date';


  Future<void> _onFetchTasks(FetchTasksEventList event, Emitter<TaskState> emit) async {
    try {
      if (_tasks.isEmpty) {
        _tasks = await taskRepository.fetchTasks();
      }
      _applyFilterAndSort();
      emit(TaskLoaded(
        tasks: _tasks,
        filteredAndSortedTasks: _filteredAndSortedTasks,
        selectedFilter: _selectedFilter,
        selectedSortOption: _selectedSortOption,
      ));
    } catch (e) {
      emit(TaskError('Failed to load tasks.'));
    }
  }

  void _onSetFilter(SetFilterEvent event, Emitter<TaskState> emit) {
    _selectedFilter = event.filter;
    _applyFilterAndSort();
    emit(TaskLoaded(
      tasks: _tasks,
      filteredAndSortedTasks: _filteredAndSortedTasks,
      selectedFilter: _selectedFilter,
      selectedSortOption: _selectedSortOption,
    ));
  }

  void _onSetSortOption(SetSortOptionEvent event, Emitter<TaskState> emit) {
    _selectedSortOption = event.sortOption;
    _applyFilterAndSort();
    emit(TaskLoaded(
      tasks: _tasks,
      filteredAndSortedTasks: _filteredAndSortedTasks,
      selectedFilter: _selectedFilter,
      selectedSortOption: _selectedSortOption,
    ));
  }

  void _onMarkTaskComplete(MarkTaskCompleteEvent event, Emitter<TaskState> emit) {
    event.task.isCompleted = !event.task.isCompleted;
    _applyFilterAndSort();
    emit(TaskLoaded(
      tasks: _tasks,
      filteredAndSortedTasks: _filteredAndSortedTasks,
      selectedFilter: _selectedFilter,
      selectedSortOption: _selectedSortOption,
    ));
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) {
    _tasks.removeWhere((task) => task.id == event.task.id);
    _applyFilterAndSort();
    emit(TaskLoaded(
      tasks: _tasks,
      filteredAndSortedTasks: _filteredAndSortedTasks,
      selectedFilter: _selectedFilter,
      selectedSortOption: _selectedSortOption,
    ));
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) {
    final index = _tasks.indexWhere((task) => task.id == event.task.id);
    if (index != -1) {
      _tasks[index] = event.task;
      _applyFilterAndSort();
      emit(TaskLoaded(
        tasks: _tasks,
        filteredAndSortedTasks: _filteredAndSortedTasks,
        selectedFilter: _selectedFilter,
        selectedSortOption: _selectedSortOption,
      ));
    }
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) {
    final searchedTasks = _tasks.where((task) {
      return task.title.toLowerCase().contains(event.query.toLowerCase());
    }).toList();
    emit(TaskSearched(searchedTasks));
  }

  void _applyFilterAndSort() {
    _filteredAndSortedTasks = _tasks.where((task) {
      if (_selectedFilter == 'Completed') return task.isCompleted;
      if (_selectedFilter == 'Pending') return !task.isCompleted;
      return true;
    }).toList();

    if (_selectedSortOption == 'Due Date') {
      _filteredAndSortedTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    } else if (_selectedSortOption == 'Alphabetical') {
      _filteredAndSortedTasks.sort((a, b) => a.title.compareTo(b.title));
    }
  }
}