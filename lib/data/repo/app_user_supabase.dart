import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/app_user.dart';

class AppUserSupabase {
  static final AppUserSupabase _instance = AppUserSupabase._init();
  AppUserSupabase._init();
  factory AppUserSupabase() => _instance;

  static final _supabase = Supabase.instance.client;
  static const _table = "app_users";

  Future<List<AppUser>> getUsers() async {
    final res = await _supabase
        .from(_table)
        .select()
        .order("created_at", ascending: false);
    return res.map((map) => AppUser.fromMap(map)).toList();
  }

  Future<AppUser?> getUserById(String id) async {
    final res =
        await _supabase.from(_table).select().eq("id", id).maybeSingle();
    return res != null ? AppUser.fromMap(res) : null;
  }

  Future<void> addUser(AppUser user) async {
    await _supabase.from(_table).insert(user.toMap());
  }

  Future<void> updateUser(AppUser user) async {
    await _supabase.from(_table).update(user.toMap()).eq("id", user.id);
  }
}
