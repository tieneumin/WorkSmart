import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:worksmart/widgets/_timesheet_chart.dart';

class TimesheetsScreen extends StatefulWidget {
  const TimesheetsScreen({super.key, this.userId, this.email});
  final String? userId;
  final String? email;

  @override
  State<TimesheetsScreen> createState() => _TimesheetsScreenState();
}

class _TimesheetsScreenState extends State<TimesheetsScreen> {
  final _repo = TimesheetSupabase();
  var _timesheets = <Timesheet>[];
  bool _isLoading = true;

  bool _initProvider = false;
  bool isOtherUser = false;
  String? _userId;

  DateTimeRange? _dateRange;
  var _filteredTimesheets = <Timesheet>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initProvider) return;
    // use UserProvider at HomeTabContainer, widget.userId if coming from UsersScreen
    isOtherUser = widget.userId != null;
    final currentUser = context.watch<UserProvider>().user;
    if (isOtherUser) {
      _userId = widget.userId;
    } else if (currentUser != null) {
      _userId = currentUser.id;
    } else {
      return; // wait for UserProvider
    }
    _refresh();
    _initProvider = true;
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getTimesheetsByUserId(_userId!);
      _timesheets = res;
      _isLoading = false;
      if (!mounted) return;
      _applyFilter();
    } on PostgrestException {
      showSnackbar("Failed to load timesheets", context);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      // build range in UTC '.' Supabase times stored in UTC
      _dateRange = DateTimeRange(
        start: DateTime.utc(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        ),
        end: DateTime.utc(picked.end.year, picked.end.month, picked.end.day),
      );
      _applyFilter();
    }
  }

  void _applyFilter() {
    if (_dateRange == null) {
      _filteredTimesheets = _timesheets;
    } else {
      _filteredTimesheets =
          _timesheets
              .where(
                (timesheet) =>
                    // e.g. when filtering 3rd to 5th, check 3rd 0000 to 5th 2359
                    timesheet.date.compareTo(_dateRange!.start) >= 0 &&
                    timesheet.date.compareTo(
                          _dateRange!.end.add(const Duration(days: 1)),
                        ) <
                        0,
              )
              .toList();
    }
    setState(() {}); // triggers widget rebuild with new filteredTimesheets
  }

  Future<void> _navigateToAddTimesheet() async {
    final res = await context.pushNamed(
      Screen.addTimesheet.name,
      queryParameters:
          isOtherUser ? {"userId": _userId, "email": widget.email} : {},
    );
    if (res == true) _refresh();
  }

  Future<void> _navigateToEditTimesheet(int id) async {
    final res = await context.pushNamed(
      Screen.editTimesheet.name,
      pathParameters: {"id": id.toString()},
      queryParameters: isOtherUser ? {"email": widget.email} : {},
    );
    if (res == true) _refresh();
  }

  Future<void> _deleteTimesheet(int id) async {
    final confirmed = await showDeleteDialog();
    if (confirmed) {
      try {
        await _repo.deleteTimesheet(id);
        if (mounted) showSnackbar("Timesheet deleted", context, success: true);
        _refresh();
      } catch (e) {
        if (mounted) showSnackbar("Failed to delete timesheet", context);
      }
    }
  }

  Future<bool> showDeleteDialog() async {
    return await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete timesheet?"),
            content: const Text("This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:
          isOtherUser
              ? Text(
                "Timesheets (${widget.email})",
                style: TextStyle(fontSize: 20.0),
              )
              : const Text("Timesheets"),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          tooltip: "Filter by date",
          onPressed: _pickDateRange,
        ),
        if (_dateRange != null)
          IconButton(
            onPressed: () {
              _dateRange = null;
              _applyFilter();
            },
            tooltip: "Clear filter",
            icon: const Icon(Icons.close),
          ),
      ],
    ),
    body: SafeArea(
      child:
          _isLoading || _userId == null
              ? const Center(child: CircularProgressIndicator())
              : _dateRange == null && _filteredTimesheets.isEmpty
              ? const Center(child: Text("No timesheets added"))
              : _filteredTimesheets.isEmpty
              ? const Center(child: Text("No timesheets found"))
              : RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _filteredTimesheets.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 4.0),
                  itemBuilder:
                      (context, index) => TimesheetItem(
                        timesheet: _filteredTimesheets[index],
                        onClickEdit:
                            (timesheet) =>
                                _navigateToEditTimesheet(timesheet.id!),
                        onClickDelete:
                            (timesheet) => _deleteTimesheet(timesheet.id!),
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

class TimesheetItem extends StatelessWidget {
  const TimesheetItem({
    super.key,
    required this.timesheet,
    required this.onClickEdit,
    required this.onClickDelete,
  });
  final Timesheet timesheet;
  final Function(Timesheet) onClickEdit;
  final Function(Timesheet) onClickDelete;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2.0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      title: Text(
        timesheet.date.toIso8601String().split("T")[0],
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onClickEdit(timesheet),
            tooltip: "Edit",
            icon: Icon(Icons.edit, color: Colors.blue[700]),
          ),
          IconButton(
            onPressed: () => onClickDelete(timesheet),
            tooltip: "Delete",
            icon: Icon(Icons.delete, color: Colors.red[700]),
          ),
        ],
      ),
    ),
  );
}
