import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/app_user.dart';

class AppUserSupabase {
  static final AppUserSupabase _instance = AppUserSupabase._init();
  AppUserSupabase._init();
  factory AppUserSupabase() {
    return _instance;
  }

  static final _supabase = Supabase.instance.client;
  static const _table = "users";

  Future<List<AppUser>> getAllUsers() async {
    final res = await _supabase
        .from(_table)
        .select()
        .order("created_at", ascending: false);
    return res.map((map) => AppUser.fromMap(map)).toList();
  }

  Future<AppUser?> getUserById(int id) async {
    final res =
        await _supabase.from(_table).select().eq("id", id).maybeSingle();
    return res != null ? AppUser.fromMap(res) : null; // error if not found
  }

  Future<void> addUser(AppUser user) async {
    await _supabase.from(_table).insert(user.toMap());
  }

  Future<void> updateUser(AppUser user) async {
    await _supabase.from(_table).update(user.toMap()).eq("id", user.id!);
  }

  Future<void> deleteUser(int id) async {
    await _supabase.from(_table).delete().eq("id", id);
  }
}
