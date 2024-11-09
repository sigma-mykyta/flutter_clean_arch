import 'package:details/presentation/bloc/task_details_bloc.dart';
import 'package:details/presentation/bloc/task_details_event.dart';
import 'package:details/presentation/bloc/task_details_state.dart';
import 'package:flutter/material.dart';
import 'package:common/domain/entities/task.dart';
import 'package:common/data/task_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(
        taskRepository: GetIt.I<TaskRepository>(), // Use the interface instead of implementation
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Details'),
        ),
        body: BlocListener<TaskDetailsBloc, TaskDetailsState>(
          listener: (context, state) {
            if (state is TaskDetailsDeleted) {
              Navigator.pop(context); // Go back after task is deleted
            } else if (state is TaskDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
            builder: (context, state) {
              // Use the task from state if available, otherwise use the initial task
              final currentTask = state is TaskDetailsUpdated ? state.task : task;
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTask.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // if (currentTask.dueDate != null)
                    //   Text(
                    //     'Due: ${DateFormat('MMM dd, yyyy').format(currentTask.dueDate!)}',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    SizedBox(height: 20),
                    if (state is TaskDetailsLoading)
                      Center(child: CircularProgressIndicator())
                    else
                      _buildActionButtons(context, currentTask),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            context.read<TaskDetailsBloc>().add(MarkTaskCompleteEvent(task));
          },
          icon: Icon(task.isCompleted ? Icons.undo : Icons.check_circle),
          label: Text(task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _editTask(context, task),
          icon: Icon(Icons.edit),
          label: Text('Edit Task'),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            context.read<TaskDetailsBloc>().add(DeleteTaskEvent(task.id));
          },
          icon: Icon(Icons.delete),
          label: Text('Delete Task'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _editTask(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    DateTime? selectedDate = task.dueDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Due Date'),
              subtitle: Text('xxx'),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedTask = task.copyWith(
                title: titleController.text,
                dueDate: selectedDate,
              );
              context.read<TaskDetailsBloc>().add(EditTaskEvent(updatedTask));
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}