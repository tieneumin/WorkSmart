import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/request.dart';

class RequestSupabase {
  static final RequestSupabase _instance = RequestSupabase._init();
  RequestSupabase._init();
  factory RequestSupabase() {
    return _instance;
  }

  final supabase = Supabase.instance.client;
  static const _table = "requests";

  Future<List<Request>> getAllRequests() async {
    final res = await supabase
        .from(_table)
        .select()
        .order("created_at", ascending: false);
    return res.map((map) => Request.fromMap(map)).toList();
  }

  Future<Request?> getRequestById(int id) async {
    final res = await supabase.from(_table).select().eq("id", id).maybeSingle();
    return res != null ? Request.fromMap(res) : null; // error if not found
  }

  Future<void> addRequest(Request request) async {
    await supabase.from(_table).insert(request.toMap());
  }

  Future<void> updateRequest(Request request) async {
    await supabase.from(_table).update(request.toMap()).eq("id", request.id!);
  }
}
