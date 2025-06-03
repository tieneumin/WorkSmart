import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';

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
    _authService.listenForSignIn(context);
    super.initState();
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
      if (!mounted) return;
    } on AuthException catch (e) {
      showSnackbar(e.message, context);
    } on PostgrestException catch (e) {
      showSnackbar(e.message, context);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      if (!mounted) return;
    } on AuthException catch (e) {
      showSnackbar(e.message, context);
    } on PostgrestException catch (e) {
      showSnackbar(e.message, context);
    }
  }

  void _navigateToSignUp() => context.pushNamed(Screen.signUp.name);

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
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4.0,
              color: Colors.white,
              margin: const EdgeInsets.all(24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/logo.png"),
                    const SizedBox(height: 24.0),
                    TextField(
                      controller: _emailController,
                      autofocus: true,
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
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    FilledButton(
                      onPressed: _signInWithPassword,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48.0),
                      ),
                      child: const Text("Log In"),
                    ),
                    const SizedBox(height: 16.0),
                    FilledButton.icon(
                      onPressed: _signInWithGoogle,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48.0),
                      ),
                      label: const Text("Log in with Google"),
                      icon: Image.asset(
                        "assets/google.png",
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: _navigateToSignUp,
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
