import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list/presentation/bloc/task_bloc.dart';
import 'package:list/presentation/bloc/task_event.dart';
import 'package:list/presentation/bloc/task_state.dart';
import 'package:list/presentation/widgets/task_card.dart';
import 'package:common/data/task_repository_impl.dart';


class TaskSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Dispatch search event when user searches for a query
    context.read<TaskBloc>().add(SearchTasksEvent(query));

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskSearched) {
          final results = state.searchedTasks;

          if (results.isEmpty) {
            return Center(child: Text('No tasks found.'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return TaskCard(task: results[index]);
            },
          );
        } else if (state is TaskLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return Center(child: Text('Search for tasks.'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can add suggestions logic here if needed
    return Container();
  }
}