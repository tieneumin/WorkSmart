import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';

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
  bool _isSaving = false;

  @override
  void initState() {
    _authService.listenForSignIn(context);
    super.initState();
  }

  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPass = _confirmPassController.text;

    if (email.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      setState(() {
        if (email.isEmpty) _emailError = "Email is required";
        if (password.isEmpty) _passwordError = "Password is required";
        if (confirmPass.isEmpty) _confirmPassError = "Confirm passwords match";
      });
      return;
    }
    if (password != confirmPass) {
      showSnackbar("Passwords do not match", context);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _authService.signUp(email, password);
      if (!mounted) return;
    } on AuthException catch (e) {
      showSnackbar(e.message, context);
      setState(() => _isSaving = false);
    } on PostgrestException {
      showSnackbar("Failed to create user", context);
      setState(() => _isSaving = false);
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
  Widget build(BuildContext context) => Scaffold(
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
                children: [
                  Image.asset("assets/images/logo.png"),
                  const SizedBox(height: 24.0),
                  TextField(
                    autofocus: true,
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
                            () =>
                                setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    obscureText: _hideConfirmPass,
                    controller: _confirmPassController,
                    onChanged: (_) => setState(() => _confirmPassError = null),
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
                  const SizedBox(height: 24.0),
                  _isSaving
                      ? const CircularProgressIndicator()
                      : FilledButton(
                        onPressed: _signUp,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48.0),
                        ),
                        child: const Text("Sign Up"),
                      ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text("Already have an account? Log in"),
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
