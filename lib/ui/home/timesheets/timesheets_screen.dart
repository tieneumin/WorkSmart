import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/widgets/_timesheet_chart.dart';

class TimesheetsScreen extends StatefulWidget {
  const TimesheetsScreen({super.key});

  @override
  State<TimesheetsScreen> createState() => _TimesheetsScreenState();
}

class _TimesheetsScreenState extends State<TimesheetsScreen> {
  final _repo = TimesheetSupabase();
  var _timesheets = <Timesheet>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    final res = await _repo.getTimesheets();
    if (!mounted) return;
    setState(() {
      _timesheets = res;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAddTimesheet() async {
    var res = await context.pushNamed(Screen.addTimesheet.name);
    if (res == true) _refresh();
  }

  Future<void> _navigateToEditTimesheet(int id) async {
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
                : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _timesheets.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 4.0),
                    itemBuilder:
                        (context, index) => TimesheetItem(
                          timesheet: _timesheets[index],
                          onClickItem:
                              (timesheet) =>
                                  _navigateToEditTimesheet(timesheet.id!),
                        ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTimesheet,
        icon: const Icon(Icons.add),
        label: const Text("Add Timesheet"),
      ),
    );
  }
}

class TimesheetItem extends StatelessWidget {
  const TimesheetItem({
    super.key,
    required this.timesheet,
    required this.onClickItem,
  });
  final Timesheet timesheet;
  final Function(Timesheet) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () => onClickItem(timesheet),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timesheet.date.toIso8601String().split("T")[0],
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Hours worked: ${timesheet.hours.toString()}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4.0),
              Text(
                "Added: ${timesheet.createdAt.toString().split(".")[0]}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
