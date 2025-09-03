import 'package:community/screens/auth/view/app_disabled.dart';
import 'package:community/screens/doc_details/view/doc_renderer.dart';

import '../screens/profile/view/profile_page.dart';
import '../screens/splash_screen/view/splash_screen.dart';
import '../router/routing_constants.dart';
import '../router/undefined_view.dart';
import '../screens/home/view/home.dart';
import '../screens/past_attendance_request/view/AttendanceRequest.dart';
import '../screens/leave_application/view/leave_application.dart';
import '../screens/expense_claim/view/expense_claim.dart';
import '../screens/issue_tracker/view/issue_tracker.dart';
import '../screens/monthly_data/view/monthly_data.dart';
import '../screens/salary_slips/view/salary_slips.dart';
import '../screens/task_list/view/task_list.dart';
import '../screens/timesheet/view/timesheet.dart';
import '../screens/todo_list/view/todo_list.dart';
import 'package:flutter/material.dart';

import '../screens/auth/view/auth_page.dart';
import '../screens/base_url/view/base_url.dart';
import '../screens/notification/view/notification.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreenViewRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case homeScreenViewRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case baseUrl:
      return MaterialPageRoute(builder: (context) => BaseURL());
    case authScreen:
      return MaterialPageRoute(builder: (context) => AuthPage());
    case pastAttendanceScreen:
      return MaterialPageRoute(builder: (context) => AttendanceRequest());
    case leaveApplicationScreen:
      return MaterialPageRoute(builder: (context) => LeaveApplication());
    case expenseClaimScreen:
      return MaterialPageRoute(builder: (context) => ExpenseClaim());
    case issueTrackerScreen:
      return MaterialPageRoute(builder: (context) => IssueTracker());
    case salarySlipScreen:
      return MaterialPageRoute(builder: (context) => SalarySlip());
    case attendancerecordScreen:
      return MaterialPageRoute(builder: (context) => MonthlyData());
    case todolistScreen:
      return MaterialPageRoute(builder: (context) => TodoList());
    case timesheetScreen:
      return MaterialPageRoute(builder: (context) => TimeSheet());
    case tasklistScreen:
      return MaterialPageRoute(builder: (context) => TaskList());
    case notificationScreen:
      return MaterialPageRoute(builder: (context) => NotificationPage());
    case profileScreen:
      return MaterialPageRoute(builder: (context) => ProfilePage());
    case docDetailsScreen:
      return MaterialPageRoute(builder: (context) => DocRenderer(doctype: settings.arguments));
    case appDisabledScreen:
      return MaterialPageRoute(builder: (context) => AppDisabled());
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(name: settings.name));
  }
}
