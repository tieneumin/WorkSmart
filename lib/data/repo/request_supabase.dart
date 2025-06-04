import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/request.dart';

class RequestSupabase {
  static final RequestSupabase _instance = RequestSupabase._init();
  RequestSupabase._init();
  factory RequestSupabase() => _instance;

  static final _supabase = Supabase.instance.client;
  static const _table = "requests";

  Future<List<Request>> getRequests({String? userId}) async {
    var query = _supabase.from(_table).select("*, app_users(email)");
    // filter for employees but not HR
    if (userId != null) query = query.eq("user_id", userId);
    final res = await query.order("created_at", ascending: false);
    return res.map((map) => Request.fromMap(map)).toList();
  }

  Future<Request?> getRequestById(int id) async {
    final res =
        await _supabase
            .from(_table)
            .select("*, app_users(email)")
            .eq("id", id)
            .maybeSingle();
    return res != null ? Request.fromMap(res) : null;
  }

  Future<void> addRequest(Request request) async {
    await _supabase.from(_table).insert(request.toMap());
  }

  Future<void> updateRequest(Request request) async {
    await _supabase.from(_table).update(request.toMap()).eq("id", request.id!);
  }
}
