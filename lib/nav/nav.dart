import 'package:go_router/go_router.dart';
import 'package:worksmart/ui/auth/login_screen.dart';
import 'package:worksmart/ui/auth/sign_up_screen.dart';
import 'package:worksmart/ui/home/home_tab_container.dart';
import 'package:worksmart/ui/home/timesheets/add_timesheet_screen.dart';
import 'package:worksmart/ui/home/timesheets/edit_timesheet_screen.dart';
import 'package:worksmart/ui/home/requests/add_request_screen.dart';
import 'package:worksmart/ui/home/requests/request_details_screen.dart';
import 'package:worksmart/ui/home/timesheets/timesheets_screen.dart';
import 'package:worksmart/ui/home/users/add_user_screen.dart';
import 'package:worksmart/ui/home/users/edit_user_screen.dart';

class Nav {
  static const initial = "/login";
  static final routes = [
    GoRoute(
      path: "/login",
      name: Screen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/sign_up",
      name: Screen.signUp.name,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: "/",
      name: Screen.home.name,
      builder: (context, state) => const HomeTabContainer(),
    ),
    GoRoute(
      path: "/timesheets/add",
      name: Screen.addTimesheet.name,
      builder:
          (context, state) => AddTimesheetScreen(
            userId: state.uri.queryParameters["userId"],
            email: state.uri.queryParameters["email"],
          ),
    ),
    GoRoute(
      path: "/timesheets/:id/edit",
      name: Screen.editTimesheet.name,
      builder:
          (context, state) => EditTimesheetScreen(
            id: state.pathParameters["id"]!,
            email: state.uri.queryParameters["email"],
          ),
    ),
    GoRoute(
      path: "/requests/add",
      name: Screen.addRequest.name,
      builder: (context, state) => const AddRequestScreen(),
    ),
    GoRoute(
      path: "/requests/:id",
      name: Screen.requestDetails.name,
      builder:
          (context, state) =>
              RequestDetailsScreen(id: state.pathParameters["id"]!),
    ),
    GoRoute(
      path: "/users/add",
      name: Screen.addUser.name,
      builder: (context, state) => const AddUserScreen(),
    ),
    GoRoute(
      path: "/users/:id/timesheets",
      name: Screen.userTimesheets.name,
      builder:
          (context, state) => TimesheetsScreen(
            userId: state.pathParameters["id"],
            email: state.uri.queryParameters["email"],
          ),
    ),
    GoRoute(
      path: "/users/:id/edit",
      name: Screen.editUser.name,
      builder:
          (context, state) => EditUserScreen(id: state.pathParameters["id"]!),
    ),
  ];
}

enum Screen {
  payslip,
  login,
  signUp,
  home,
  addTimesheet,
  editTimesheet,
  addRequest,
  requestDetails,
  addUser,
  userTimesheets,
  editUser,
}
