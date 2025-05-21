import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/secrets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

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
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // TODO?
    } catch (e) {
      if (mounted) showErrorSnackbar(e.toString(), context);
    }
  }

  Future<void> _googleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn(serverClientId: supabaseClientId);
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) throw "No access token found";
      if (idToken == null) throw "No ID token found";

      final res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // TODO: save in users
      debugPrint("${res.user} --- ${res.session}");
    } catch (e) {
      if (mounted) showErrorSnackbar(e.toString(), context);
    }
  }

  void _navigateToSignUp() {
    context.pushNamed(Screen.signup.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
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
              FilledButton(
                onPressed: _signInWithPassword,
                child: const Text("Sign in"),
              ),
              const SizedBox(height: 8.0),
              FilledButton.icon(
                onPressed: _googleSignIn,
                label: const Text("Sign in with Google"),
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
