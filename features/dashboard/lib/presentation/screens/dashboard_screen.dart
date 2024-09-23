import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/presentation/bloc/task_bloc.dart';
import 'package:dashboard/presentation/widgets/progress_bar.dart';
import 'package:dashboard/presentation/widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // Navigate to the Task List screen
              Navigator.pushNamed(context, '/task_list');
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return Column(
              children: [
                Text('Task Progress', style: TextStyle(fontSize: 24)),
                ProgressBar(percentage: state.progress),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: state.tasks[index]);
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
          BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent());
        },
        child: Icon(Icons.refresh),
      ),
      
    );
  }
}