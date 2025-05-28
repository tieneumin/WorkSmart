import 'package:go_router/go_router.dart';
import 'package:worksmart/ui/auth/login_screen.dart';
import 'package:worksmart/ui/auth/sign_up_screen.dart';
import 'package:worksmart/ui/home/home_tab_container.dart';
import 'package:worksmart/ui/home/timesheets/add_timesheet_screen.dart';
import 'package:worksmart/ui/home/requests/add_request_screen.dart';
import 'package:worksmart/ui/home/users/add_user_screen.dart';

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
      builder: (context, state) => const AddTimesheetScreen(),
    ),
    // GoRoute(
    //   path: "/timesheets/edit/:id",
    //   name: Screen.editTimesheet.name,
    //   builder: (context, state)=> EditTimesheetScreen(id: state.pathParameters["id"]!),
    // ),
    GoRoute(
      path: "/requests/add",
      name: Screen.addRequest.name,
      builder: (context, state) => const AddRequestScreen(),
    ),
    // GoRoute(
    //   path: "/requests/edit/:id",
    //   name: Screen.editRequest.name,
    //   builder: (context, state)=> EditRequestScreen(id: state.pathParameters["id"]!),
    // ),
    GoRoute(
      path: "/users/add",
      name: Screen.addUser.name,
      builder: (context, state) => const AddUserScreen(),
    ),
    // GoRoute(
    //   path: "/users/edit/:id",
    //   name: Screen.editUser.name,
    //   builder: (context, state) => EditUserScreen(id: state.pathParameters["id"]!),
    // ),
  ];
}

enum Screen {
  login,
  signUp,
  home,
  addTimesheet,
  editTimesheet,
  addRequest,
  requestDetails,
  addUser,
  editUser,
}
