import 'package:flutter/material.dart';
import 'package:worksmart/ui/home/employee/employee_screen.dart';
import 'package:worksmart/ui/home/employer/employer_screen.dart';

class HomeTabContainer extends StatefulWidget {
  const HomeTabContainer({super.key});

  @override
  State<HomeTabContainer> createState() => _HomeTabContainerState();
}

class _HomeTabContainerState extends State<HomeTabContainer> {
  late final List<Widget> _tabs;

  @override
  void initState() {
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
    super.initState();
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
      length: _tabs.length,
      child: Scaffold(
        body: TabBarView(
          children: [TestEmployeeScreen(), TestEmployerScreen()],
        ),
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
