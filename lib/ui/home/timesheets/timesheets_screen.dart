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

class _TimesheetsScreenState extends State<TimesheetsScreen> {
  final _repo = TimesheetSupabase();
  var _timesheets = <Timesheet>[];

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    final res = await _repo.getTimesheets();
    debugPrint(res.toString());
    setState(() {
      _timesheets = res;
    });
  }

  void _navigateToAdd() async {
    var res = await context.pushNamed(Screen.addTimesheet.name);
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timesheets')),
      body: SafeArea(
        child: Column(
          children: [
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
                    // onClickItem: (id) => _navigateToDetails(),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
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
  // final Function(int) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      // child: GestureDetector(
      //   onTap: () => onClickItem(timesheet.id!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timesheet.date.toIso8601String(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(timesheet.hours.toString()),
        ],
      ),
      // ),
    );
  }
}
