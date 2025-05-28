import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/widgets/timesheet_chart.dart';

class TimesheetsScreen extends StatefulWidget {
  const TimesheetsScreen({super.key});

  @override
  State<TimesheetsScreen> createState() => _TimesheetsScreenState();
}

// filter by user if employee; if HR clicks, filter by said user_id
class _TimesheetsScreenState extends State<TimesheetsScreen> {
  static final _repo = TimesheetSupabase();
  var _timesheets = <Timesheet>[];
  late bool _isLoading;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    setState(() => _isLoading = true);
    final res = await _repo.getTimesheets();
    if (!mounted) return;
    setState(() {
      _timesheets = res;
      _isLoading = false;
    });
  }

  void _navigateToAddTimesheet() async {
    var res = await context.pushNamed(Screen.addTimesheet.name);
    if (res == true) _refresh();
  }

  void _navigateToEditTimesheet(int id) async {
    var res = await context.pushNamed(
      Screen.editTimesheet.name,
      pathParameters: {"id": id.toString()},
    );
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timesheets")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _timesheets.isEmpty
                ? const Center(child: Text("No timesheets added"))
                :
                // child: Column(
                //   children: [
                // TimesheetChart(
                //   dates: [
                //     DateTime(2025, 5, 20),
                //     DateTime(2025, 5, 21),
                //     DateTime(2025, 5, 22),
                //   ],
                //   hours: [6.0, 7.5, 8.0],
                // ),
                ListView.builder(
                  itemCount: _timesheets.length,
                  itemBuilder:
                      (context, index) => TimesheetItem(
                        timesheet: _timesheets[index],
                        // onClickItem: (timesheet) => _navigateToDetails(timesheet.id!),
                      ),
                ),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTimesheet,
        child: Icon(Icons.add),
      ),
    );
  }
}

class TimesheetItem extends StatelessWidget {
  const TimesheetItem({
    super.key,
    required this.timesheet,
    // required this.onClickItem,
  });
  final Timesheet timesheet;
  // final Function(Timesheet) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      // child: GestureDetector(
      //   onTap: () => onClickItem(timesheet),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timesheet.date.toIso8601String().split("T")[0],
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text("${timesheet.hours.toString()} hours"),
        ],
      ),
      // ),
    );
  }
}
