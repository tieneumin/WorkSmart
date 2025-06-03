import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:worksmart/ui/home/timesheets/timesheets_screen.dart';
import 'package:worksmart/ui/home/requests/requests_screen.dart';
import 'package:worksmart/ui/home/users/users_screen.dart';
import 'package:worksmart/ui/home/profile_screen.dart';

class HomeTabContainer extends StatefulWidget {
  const HomeTabContainer({super.key});

  @override
  State<HomeTabContainer> createState() => _HomeTabContainerState();
}

class _HomeTabContainerState extends State<HomeTabContainer> {
  var _screens = <Widget>[];
  var _tabs = <Widget>[];
  bool _initProvider = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initProvider) return;
    final currentUser = context.watch<UserProvider>().user;
    if (currentUser != null) {
      _initScreensByRole(currentUser.role);
      _initProvider = true;
    }
  }

  void _initScreensByRole(String role) {
    _screens = [
      TimesheetsScreen(),
      RequestsScreen(),
      if (role == "HR") UsersScreen(),
      ProfileScreen(),
    ];
    _tabs = [
      _tabBarItem("Timesheets", Icons.punch_clock),
      _tabBarItem("Requests", Icons.fact_check),
      if (role == "HR") _tabBarItem("Users", Icons.group),
      _tabBarItem("Profile", Icons.person),
    ];
  }

  Widget _tabBarItem(String title, IconData icon) {
    return SizedBox(
      height: 48.0,
      child: Column(
        children: [Icon(icon), Text(title, overflow: TextOverflow.ellipsis)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_screens.isEmpty || _screens.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        body: TabBarView(children: _screens),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs,
        ),
      ),
    );
  }
}
