// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:worksmart/lib/data/model/timesheet.dart';

// class TimesheetRepoSupabase {
//   static final TimesheetRepoSupabase _instance = TimesheetRepoSupabase._init();
//   TimesheetRepoSupabase._init();
//   factory TimesheetRepoSupabase() {
//     return _instance;
//   }

//   final supabase = Supabase.instance.client;

//   Future<void> addTimesheet(Timesheet timesheet) async {
//     await supabase.from('timesheets').insert(timesheet.toMap());
//   }

//   Future<List<Timesheet>> getAllTimesheets() async {
//     final resp = await supabase
//         .from('timesheets')
//         .select()
//         .order('id', ascending: true);
//     return resp.map((map) => Timesheet.fromMap(map)).toList();
//   }

//   Future<Timesheet> getTimesheetById(int id) async {
//     final resp = await supabase.from('timesheets').select().eq('id', id).single();
//     return Timesheet.fromMap(resp);
//   }

//   Future<void> updateTimesheet(Timesheet timesheet) async {
//     // eq ≈ WHERE
//     await supabase.from('timesheets').update(timesheet.toMap()).eq('id', timesheet.id!);
//   }

//   Future<void> deleteTimesheet(int id) async {
//     await supabase.from('timesheets').delete().eq('id', id);
//   }
// }
