import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    if (user == null) {
      return const Center(child: Text("No user data"));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email: ${user.email}",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Role: ${user.role}",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Salary: \$${user.salary.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: FilledButton.icon(
                  onPressed: _authService.signOut,
                  label: const Text("Log Out"),
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
