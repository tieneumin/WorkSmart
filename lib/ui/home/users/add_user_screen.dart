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
  String? _role;
  String? _emailError;
  String? _passwordError;
  String? _confirmPassError;
  String? _salaryError;
  String? _roleError;
  bool _hidePassword = true;
  bool _hideConfirmPass = true;
  bool _isSaving = false;

  Future<void> _createUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPass = _confirmPassController.text;
    final salaryText = _salaryController.text;
    final salary = double.tryParse(salaryText);

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPass.isEmpty ||
        salaryText.isEmpty ||
        _role == null) {
      setState(() {
        if (email.isEmpty) _emailError = "Email is required";
        if (password.isEmpty) _passwordError = "Password is required";
        if (confirmPass.isEmpty) _confirmPassError = "Confirm passwords match";
        if (salaryText.isEmpty) _salaryError = "Salary is required";
        if (_role == null) _roleError = "Role is required";
      });
      return;
    }
    if (password != confirmPass) {
      showSnackbar("Passwords do not match", context);
      return;
    }
    if (salary == null || salary < 0) {
      setState(() => _salaryError = "Enter a valid salary");
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _authService.internalSignUp(email, password, salary, _role!);
      if (!mounted) return;
      context.pop(true);
    } on AuthException catch (e) {
      showSnackbar(e.message, context);
      setState(() => _isSaving = false);
    } on PostgrestException {
      showSnackbar("Failed to create user", context);
      setState(() => _isSaving = false);
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Create User")),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                  obscureText: _hidePassword,
                  controller: _passwordController,
                  onChanged: (_) => setState(() => _passwordError = null),
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: _passwordError,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed:
                          () => setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
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
                      onPressed:
                          () => setState(
                            () => _hideConfirmPass = !_hideConfirmPass,
                          ),
                      icon: Icon(
                        _hideConfirmPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _salaryController,
                  onChanged: (_) => setState(() => _salaryError = null),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Salary",
                    errorText: _salaryError,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: _role,
                  items: const [
                    DropdownMenuItem(value: null, child: Text("Select a role")),
                    DropdownMenuItem(
                      value: "Employee",
                      child: Text("Employee"),
                    ),
                    DropdownMenuItem(value: "HR", child: Text("HR")),
                  ],
                  onChanged: (value) {
                    setState(() => _role = value);
                    if (value != null) setState(() => _roleError = null);
                  },
                  decoration: InputDecoration(
                    labelText: "Role",
                    errorText: _roleError,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24.0),
                _isSaving
                    ? const CircularProgressIndicator()
                    : FilledButton(
                      onPressed: _createUser,
                      child: const Text("Create"),
                    ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
