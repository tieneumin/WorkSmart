import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_id_provider.dart';
import 'package:worksmart/ui/home/add_request_screen.dart';
import 'package:worksmart/ui/home/employee/employee_screen.dart';
import 'package:worksmart/ui/home/employer/employer_screen.dart';
import 'package:worksmart/ui/home/requests_screen.dart';

class HomeTabContainer extends StatefulWidget {
  const HomeTabContainer({super.key});

  @override
  State<HomeTabContainer> createState() => _HomeTabContainerState();
}

class _HomeTabContainerState extends State<HomeTabContainer> {
  // late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    context.read<UserIdProvider>().getCurrentUserId();

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
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [TestEmployeeScreen(), AddRequestScreen()]),
        // body: TabBarView(children: _tabs),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.black,
          // indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            _tabBarItem("Employee", Icons.home),
            _tabBarItem("Employer", Icons.person),
          ],
        ),
      ),
    );
  }
}
