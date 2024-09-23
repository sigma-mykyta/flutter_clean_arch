import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/presentation/bloc/task_bloc.dart';
import 'package:dashboard/presentation/screens/dashboard_screen.dart';
import 'package:dashboard/data/task_repository_impl.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configureDependencies();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (_) => getIt<TaskRepository>(),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            taskRepository: context.read<TaskRepository>(),
          )..add(FetchTasksEvent()), 
        ),
      ],
      child: MaterialApp(
        title: 'Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashboardScreen(),
      ),
    );
  }
}