import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:worksmart/ui/home/timesheets/timesheets_screen.dart';
import 'package:worksmart/ui/home/requests/requests_screen.dart';
import 'package:worksmart/ui/home/users/users_screen.dart';
import 'package:worksmart/ui/home/templates/_employee_screen.dart';
import 'package:worksmart/ui/home/templates/_employer_screen.dart';
import 'package:worksmart/ui/home/profile_screen.dart';

class HomeTabContainer extends StatefulWidget {
  const HomeTabContainer({super.key});

  @override
  State<HomeTabContainer> createState() => _HomeTabContainerState();
}

class _HomeTabContainerState extends State<HomeTabContainer> {
  final _authService = AuthService();
  late final List<Widget> _screens;
  // late final List<Widget> _tabs;

  @override
  void initState() {
    _authService.listenForAuthChanges(context);
    _screens = [
      TimesheetsScreen(),
      RequestsScreen(),
      // UsersScreen(),
      // TestEmployeeScreen(),
      // TestEmployerScreen(),
      ProfileScreen(),
    ];
    super.initState();

    // // for logout
    //   context.read<UserIdProvider>().clearUserId();

    // _tabs =
    //     getUserById(_).role == "employer"
    //         ? [
    //           _tabBarItem("Requests", Icons.approval),
    //           _tabBarItem("Profile", Icons.person),
    //         ]
    //         : [
    //           _tabBarItem("Requests", Icons.approval),
    //           _tabBarItem("Profile", Icons.person),
    //         ];
  }

  Widget _tabBarItem(String title, IconData icon) {
    return SizedBox(
      height: 48.0,
      child: Column(children: [Icon(icon), Text(title)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        body: TabBarView(children: _screens),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.black,
          // indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            _tabBarItem("Timesheets", Icons.more_time),
            _tabBarItem("Requests", Icons.fact_check),
            // _tabBarItem("Users", Icons.people),
            // _tabBarItem("Employee", Icons.work),
            // _tabBarItem("Employer", Icons.person),
            _tabBarItem("Profile", Icons.settings),
          ],
        ),
      ),
    );
  }
}
