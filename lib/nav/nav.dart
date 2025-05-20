import 'package:go_router/go_router.dart';
import 'package:worksmart/ui/auth/login_screen.dart';
import 'package:worksmart/ui/auth/sign_up_screen.dart';
import 'package:worksmart/ui/employee/employee_tab_container.dart';

class Nav {
  static const initial = "/login";
  static final routes = [
    GoRoute(
      path: "/login",
      name: Screen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/signup",
      name: Screen.signup.name,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: "/employee",
      name: Screen.employeeHome.name,
      builder: (context, state) => const EmployeeTabContainer(),
    ),
    // GoRoute(
    //   path: "/employer",
    //   name: Screen.employerHome.name,
    //   builder: (context, state) => const EmployerHomeScreen(),
    // ),
  ];
}

enum Screen { login, signup, employeeHome, employerHome }
