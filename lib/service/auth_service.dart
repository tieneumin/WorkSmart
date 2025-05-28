import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worksmart/secrets.dart';

class AuthService {
  static final AuthService _instance = AuthService._init();
  AuthService._init();
  factory AuthService() => _instance;

  static final _supabase = Supabase.instance.client;
  static final _userRepo = AppUserSupabase();

  User? get _currentUser => _supabase.auth.currentUser;
  Future<AppUser?> getCurrentUserById() async =>
      await _userRepo.getUserById(_currentUser!.id);

  void listenForAuthChanges(BuildContext context) {
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (context.mounted) {
          context.read<UserProvider>().getCurrentUser();
          context.pushReplacementNamed(Screen.home.name);
        }
      } else if (data.event == AuthChangeEvent.signedOut) {
        if (context.mounted) {
          context.read<UserProvider>().clearUser();
          context.pushReplacementNamed(Screen.login.name);
        }
      }
    });
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
    // final res = await _supabase.auth.signUp(email: email, password: password);
    // if (res.user != null) {
    //   final id = res.user!.id;
    //   await _userRepo.addUser(AppUser(id: id, email: email));
    // }
    // return res;
  }

  // Future<void> internalSignUp(
  //   String email,
  //   String password,
  //   String role,
  //   double salary,
  // ) async {
  //   final res = await _supabase.auth.signUp(email: email, password: password);
  //   if (res.user != null) {
  //     final id = res.user!.id;
  //     await _userRepo.addUser(
  //       AppUser(id: id, email: email, role: role, salary: salary),
  //     );
  //   }
  // }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.user != null) {
      final id = _currentUser!.id;
      final user = await getCurrentUserById();
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

    final res = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    if (res.user != null) {
      final id = _currentUser!.id;
      final email = _currentUser!.email;
      final user = await getCurrentUserById();
      if (user == null) await _userRepo.addUser(AppUser(id: id, email: email!));
    }
    return res;
  }

  Future<void> signOut() async => await _supabase.auth.signOut();
}
