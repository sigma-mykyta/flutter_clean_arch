import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:list/presentation/task_list_screen.dart';
import 'package:dashboard/presentation/bloc/dashboard_task_bloc.dart';
import 'package:dashboard/presentation/screens/dashboard_screen.dart';
import 'package:common/data/task_repository_impl.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configureDependencies();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider for managing tasks across the app
       BlocProvider<DashboardTaskBloc>(
          create: (context) => DashboardTaskBloc(
            taskRepository: GetIt.I<TaskRepository>(),
          )..add(FetchTasksEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashboardScreen(), 
        routes: {
          '/task_list': (context) => TaskListScreen(),
        },
      )
    );
  }
}