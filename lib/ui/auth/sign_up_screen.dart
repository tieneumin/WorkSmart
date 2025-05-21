import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:worksmart/nav/nav.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPassError;
  bool _obscurePassword = true;
  bool _obscureConfirmPass = true;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (mounted) {
          context.pushReplacementNamed(Screen.employeeHome.name);
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
        if (confirmPass.isEmpty) {
          _confirmPassError = "Field is required";
        }
      });
      return;
    }
    if (password != confirmPass) {
      showErrorSnackbar("Passwords do not match", context);
      return;
    }

    try {
      final res = await supabase.auth.signUp(email: email, password: password);

      // TODO: save in users
      debugPrint("${res.user} --- ${res.session}");
    } catch (e) {
      if (mounted) showErrorSnackbar(e.toString(), context);
    }
  }

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
      appBar: AppBar(title: const Text("Sign Up")),
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
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                onChanged: (_) => setState(() => _passwordError = null),
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPassController,
                onChanged: (_) => setState(() => _confirmPassError = null),
                obscureText: _obscureConfirmPass,
                decoration: InputDecoration(
                  labelText: "Confirm password",
                  errorText: _confirmPassError,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPass
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscureConfirmPass = !_obscureConfirmPass,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              FilledButton(onPressed: _signUp, child: const Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
