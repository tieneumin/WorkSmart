import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    _authService.listenForSignOut(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) return const Center(child: Text("No user data"));

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle, size: 64.0),
                  const SizedBox(height: 16.0),
                  Text(
                    "Email: ${user.email}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Salary: RM${user.salary.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Role: ${user.role}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 24.0),
                  FilledButton.icon(
                    onPressed: _authService.signOut,
                    label: const Text("Log Out"),
                    icon: const Icon(Icons.logout),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
