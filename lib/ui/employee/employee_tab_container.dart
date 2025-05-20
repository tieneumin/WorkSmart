import 'package:flutter/material.dart';

class EmployeeTabContainer extends StatefulWidget {
  const EmployeeTabContainer({super.key});

  @override
  State<EmployeeTabContainer> createState() => _EmployeeTabContainerState();
}

class _EmployeeTabContainerState extends State<EmployeeTabContainer> {
  // Widget _tabBarItem(String title, IconData icon) {
  //   return SizedBox(
  //     height: 50.0,
  //     child: Column(children: [Icon(icon), Text(title)]),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return const Text("Employee Home Screen");
    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(title: const Text("Tab Navigation")),
    //     body: const TabBarView(children: [HomeScreen(), ProfileScreen()]),
    //     bottomNavigationBar: TabBar(
    //       indicatorColor: Colors.black,
    //       // indicatorColor: Colors.transparent,
    //       labelColor: Colors.black,
    //       unselectedLabelColor: Colors.grey,
    //       tabs: [
    //         _tabBarItem("Home", Icons.home),
    //         _tabBarItem("Profile", Icons.person),
    //       ],
    //     ),
    //   ),
    // );
  }
}
