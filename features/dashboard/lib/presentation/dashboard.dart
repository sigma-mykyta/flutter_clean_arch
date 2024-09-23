library dashboard;

import 'package:injectable/injectable.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

@singleton
class DashboardService {
  String getDashboardData() {
    return "dashboard data";
  }
}