import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/request.dart';

class RequestSupabase {
  static final RequestSupabase _instance = RequestSupabase._init();
  RequestSupabase._init();
  factory RequestSupabase() {
    return _instance;
  }

  static final _supabase = Supabase.instance.client;
  static const _table = "requests";

  Future<List<Request>> getAllUsers() async {
    final res = await _supabase
        .from(_table)
        .select()
        .order("created_at", ascending: false);
    return res.map((map) => Request.fromMap(map)).toList();
  }

  Future<Request?> getUserById(int id) async {
    final res =
        await _supabase.from(_table).select().eq("id", id).maybeSingle();
    return res != null ? Request.fromMap(res) : null; // error if not found
  }

  Future<void> addUser(Request user) async {
    await _supabase.from(_table).insert(user.toMap());
  }

  Future<void> updateUser(Request user) async {
    await _supabase.from(_table).update(user.toMap()).eq("id", user.id!);
  }

  Future<void> deleteUser(int id) async {
    await _supabase.from(_table).delete().eq("id", id);
  }
}
