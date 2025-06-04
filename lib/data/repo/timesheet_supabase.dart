import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/model/timesheet.dart';

class TimesheetSupabase {
  static final TimesheetSupabase _instance = TimesheetSupabase._init();
  TimesheetSupabase._init();
  factory TimesheetSupabase() => _instance;

  static final _supabase = Supabase.instance.client;
  static const _table = "timesheets";

  Future<List<Timesheet>> getTimesheetsByUserId(String userId) async {
    final res = await _supabase
        .from(_table)
        .select()
        .eq("user_id", userId)
        .order("date", ascending: false)
        .order("created_at", ascending: false);
    return res.map((map) => Timesheet.fromMap(map)).toList();
  }

  Future<Timesheet?> getTimesheetById(int id) async {
    final res =
        await _supabase.from(_table).select().eq("id", id).maybeSingle();
    return res != null ? Timesheet.fromMap(res) : null;
  }

  Future<void> addTimesheet(Timesheet timesheet) async {
    await _supabase.from(_table).insert(timesheet.toMap());
  }

  Future<void> updateTimesheet(Timesheet timesheet) async {
    await _supabase
        .from(_table)
        .update(timesheet.toMap())
        .eq("id", timesheet.id!);
  }

  Future<void> deleteTimesheet(int id) async {
    await _supabase.from(_table).delete().eq("id", id);
  }
}
