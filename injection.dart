import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'features/dashboard/lib/injection.dart' as dashboard_injection;
// import 'task_list/injection.dart' as task_list_injection;
// import 'task_details/injection.dart' as task_details_injection;

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureInjection() {
  dashboard_injection.configureDashboardInjection();
  // task_list_injection.configureTaskListInjection();
  // task_details_injection.configureTaskDetailsInjection();
}