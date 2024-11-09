import 'package:details/presentation/screens/task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list/presentation/bloc/task_bloc.dart';
import 'package:list/presentation/bloc/task_event.dart';
import 'package:list/presentation/bloc/task_state.dart';
import 'package:list/presentation/search/task_search_delegate.dart';
import 'widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TaskSearchDelegate());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (state is TaskError) {
            return Center(child: Text('Error loading tasks: ${state.message}')); // Error state
          } else if (state is TaskLoaded) {
            // Ensure we have tasks to display
            final tasks = state.filteredAndSortedTasks;
            if (tasks.isEmpty) {
              return Center(child: Text('No tasks available.')); // Empty state
            }
            // Display the tasks using ListView.builder
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(task: task),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: Text('Something went wrong.')); // Default fallback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger task fetching when refresh button is pressed
          context.read<TaskBloc>().add(FetchTasksEventList());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}