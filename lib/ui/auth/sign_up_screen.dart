import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/core/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPassError;
  bool _hidePassword = true;
  bool _hideConfirmPass = true;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    _authService.supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (mounted) {
          context.pushReplacementNamed(Screen.home.name);
        }
      }
    });
  }

  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPass = _confirmPassController.text;

    if (email.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      setState(() {
        if (email.isEmpty) _emailError = "Field is required";
        if (password.isEmpty) _passwordError = "Field is required";
        if (confirmPass.isEmpty) _confirmPassError = "Field is required";
      });
      return;
    }
    if (password != confirmPass) {
      showErrorSnackbar("Passwords do not match", context);
      return;
    }

    try {
      await _authService.signUp(email, password);
    } on AuthException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    }
  }

  void _navigateToLogin() => context.pop();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png"),
              const SizedBox(height: 8.0),
              TextField(
                controller: _emailController,
                onChanged: (_) => setState(() => _emailError = null),
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError,
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
              FilledButton(onPressed: _signUp, child: const Text("Sign Up")),
              TextButton(
                onPressed: _navigateToLogin,
                child: const Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
