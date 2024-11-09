import 'package:common/data/task_repository_impl.dart';
import 'package:common/domain/entities/task.dart';
import 'package:details/presentation/screens/task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/presentation/bloc/dashboard_task_bloc.dart';
import 'package:dashboard/presentation/widgets/progress_bar.dart';
import 'package:dashboard/presentation/widgets/task_card.dart';
import 'package:get_it/get_it.dart';
import 'package:list/presentation/bloc/task_bloc.dart';
import 'package:list/presentation/bloc/task_event.dart';
import 'package:list/presentation/task_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () async {
                // Navigate to the Task List screen
                final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => TaskBloc(
                      taskRepository: GetIt.I<TaskRepository>())..add(FetchTasksEventList()),
                    child: TaskListScreen(),
                  ),
                ),
              );
    
              if (result == true) { // If tasks were modified
                context.read<DashboardTaskBloc>().add(FetchTasksEvent());
              }
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardTaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              return Column(
                children: [
                  Text('Task Progress', style: TextStyle(fontSize: 24)),
                  ProgressBar(percentage: _calculateProgress(state.tasks)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsScreen(task: task),
                              ),
                            );
                        });
                      },
                    ),
                  ),
                ],
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No tasks to display.'));
          },
          
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<DashboardTaskBloc>(context).add(FetchTasksEvent());
          },
          child: Icon(Icons.refresh),
        ),
      
    );
  }
  double _calculateProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }
}