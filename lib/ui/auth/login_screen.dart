import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/secrets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final supabase = Supabase.instance.client;

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

  Future<AuthResponse> _googleSignIn() async {
    final googleSignIn = GoogleSignIn(serverClientId: supabaseClientId);

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    // if (accessToken == null) throw 'No Access Token found.';
    // if (idToken == null) throw 'No ID Token found.';

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken!,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _googleSignIn(),
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}
