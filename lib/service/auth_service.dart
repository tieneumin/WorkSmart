import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worksmart/secrets.dart';

class AuthService {
  static final AuthService _instance = AuthService._init();
  AuthService._init();
  factory AuthService() => _instance;

  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(serverClientId: supabaseClientId);
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) throw "No access token found";
    if (idToken == null) throw "No ID token found";

    return await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> signOut() async => await supabase.auth.signOut();
}
