import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/core/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _hidePassword = true;

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

  Future<void> _signInWithPassword() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        if (email.isEmpty) _emailError = "Enter your email";
        if (password.isEmpty) _passwordError = "Enter your password";
      });
      return;
    }

    try {
      await _authService.signInWithPassword(email, password);
    } on AuthException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final res = await _authService.signInWithGoogle();
    } on AuthException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    }
  }

  void _navigateToSignUp() => context.pushNamed(Screen.signup.name);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              FilledButton(
                onPressed: _signInWithPassword,
                child: const Text("Log In"),
              ),
              const SizedBox(height: 8.0),
              FilledButton.icon(
                onPressed: _signInWithGoogle,
                label: const Text("Log in with Google"),
                icon: Image.asset(
                  "assets/google.png",
                  width: 24.0,
                  height: 24.0,
                ),
              ),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
