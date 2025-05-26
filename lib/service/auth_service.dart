import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worksmart/secrets.dart';

class AuthService {
  static final AuthService _instance = AuthService._init();
  AuthService._init();
  factory AuthService() => _instance;

  final supabase = Supabase.instance.client;
  final _userRepo = AppUserSupabase();

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.user != null) {
      final id = supabase.auth.currentUser!.id;
      final user = await _userRepo.getUserById(id);
      if (user == null) await _userRepo.addUser(AppUser(id: id, email: email));
    }
    return res;
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(serverClientId: supabaseClientId);
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) throw AuthException("No access token found");
    if (idToken == null) throw AuthException("No ID token found");

    final res = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    if (res.user != null) {
      final id = supabase.auth.currentUser!.id;
      final email = supabase.auth.currentUser!.email;
      final user = await _userRepo.getUserById(id);
      if (user == null) await _userRepo.addUser(AppUser(id: id, email: email!));
    }
    return res;
  }

  Future<void> signOut() async => await supabase.auth.signOut();
}
