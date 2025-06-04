import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worksmart/secrets.dart';

class AuthService {
  static final AuthService _instance = AuthService._init();
  AuthService._init();
  factory AuthService() => _instance;

  static final _supabase = Supabase.instance.client;
  static final _userRepo = AppUserSupabase();

  Future<AppUser?> getCurrentUserById() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return await _userRepo.getUserById(user.id);
  }

  String? getCurrentUserAvatarUrl() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return user.userMetadata?["avatar_url"];
  }

  void listenForSignIn(BuildContext context) {
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (!context.mounted) return;
        context.read<UserProvider>().getCurrentUser();
        context.go("/");
      }
    });
  }

  void listenForSignOut(BuildContext context) {
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        if (!context.mounted) return;
        context.read<UserProvider>().clearUser();
        context.go("/login");
      }
    });
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final res = await _supabase.auth.signUp(email: email, password: password);
    if (res.user != null) {
      final id = res.user!.id;
      await _userRepo.addUser(AppUser(id: id, email: email));
    }
    return res;
  }

  Future<void> internalSignUp(
    String email,
    String password,
    double salary,
    String role,
  ) async {
    final res = await _supabase.auth.signUp(email: email, password: password);
    if (res.user != null) {
      final id = res.user!.id;
      await _userRepo.addUser(
        AppUser(id: id, email: email, salary: salary, role: role),
      );
    }
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
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

    if (accessToken == null) throw AuthException("No access token found");
    if (idToken == null) throw AuthException("No ID token found");

    final res = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    if (res.user != null) {
      final id = res.user!.id;
      final email = res.user!.email;
      final user = await getCurrentUserById();
      if (user == null && email != null) {
        await _userRepo.addUser(AppUser(id: id, email: email));
      }
    }
    return res;
  }

  Future<void> signOut() async => await _supabase.auth.signOut();
}
