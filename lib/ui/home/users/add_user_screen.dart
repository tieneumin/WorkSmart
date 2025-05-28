import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _salaryController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPassError;
  String? _salaryError;
  String? _roleError;
  bool _hidePassword = true;
  bool _hideConfirmPass = true;
  bool _isLoading = false;

  String _role = "";

  Future<void> _createUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPass = _confirmPassController.text;
    final salary = _salaryController.text;

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPass.isEmpty ||
        salary.isEmpty ||
        _role.isEmpty) {
      setState(() {
        if (email.isEmpty) _emailError = "Email is required";
        if (password.isEmpty) _passwordError = "Password is required";
        if (confirmPass.isEmpty) _confirmPassError = "Confirm passwords match";
        if (salary.isEmpty) _salaryError = "Salary is required";
        if (_role.isEmpty) _roleError = "Role is required";
      });
      return;
    }
    if (password != confirmPass) {
      showErrorSnackbar("Passwords do not match", context);
      return;
    }
    try {
      final res = await _authService.signUp(email, password);
      // parse salary to double
      // create app user, saving role/salary
      if (res.user != null && mounted) context.pop(true);
    } on AuthException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    } on PostgrestException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create User")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                onChanged: (_) => setState(() => _emailError = null),
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                onChanged: (_) => setState(() => _passwordError = null),
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPassController,
                onChanged: (_) => setState(() => _confirmPassError = null),
                obscureText: _hideConfirmPass,
                decoration: InputDecoration(
                  labelText: "Confirm password",
                  errorText: _confirmPassError,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _hideConfirmPass = !_hideConfirmPass,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _salaryController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() => _salaryError = null),
                decoration: InputDecoration(
                  labelText: "Salary",
                  errorText: _salaryError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: "", child: Text("Select an option")),
                  DropdownMenuItem(value: "employee", child: Text("Employee")),
                  DropdownMenuItem(value: "HR", child: Text("HR")),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _role = value);
                },
                decoration: InputDecoration(
                  labelText: "Role",
                  errorText: _roleError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                    onPressed: _createUser,
                    child: const Text("Create"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
