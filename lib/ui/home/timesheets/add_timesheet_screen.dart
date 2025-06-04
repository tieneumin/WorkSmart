import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';

class AddTimesheetScreen extends StatefulWidget {
  const AddTimesheetScreen({super.key, this.userId, this.email});
  final String? userId;
  final String? email;

  @override
  State<AddTimesheetScreen> createState() => _AddTimesheetScreenState();
}

class _AddTimesheetScreenState extends State<AddTimesheetScreen> {
  final _repo = TimesheetSupabase();
  final _hoursController = TextEditingController();
  DateTime? _date;
  String? _hoursError;
  String? _dateError;
  bool _isSaving = false;

  bool isOtherUser = false;
  String? _userId;

  @override
  void initState() {
    isOtherUser = widget.userId != null;
    if (isOtherUser) {
      _userId = widget.userId;
    } else {
      _userId = context.read<UserProvider>().user!.id;
    }
    super.initState();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _addTimesheet() async {
    final hoursText = _hoursController.text;
    final hours = double.tryParse(hoursText);

    if (_date == null || hoursText.isEmpty) {
      setState(() {
        if (_date == null) _dateError = "Date is required";
        if (hoursText.isEmpty) _hoursError = "Hours are required";
      });
      return;
    }
    if (hours == null || hours < 0 || hours > 24) {
      setState(() => _hoursError = "Enter a valid number of hours");
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _repo.addTimesheet(
        Timesheet(userId: _userId!, date: _date, hours: hours),
      );
      if (!mounted) return;
      context.pop(true);
    } on PostgrestException {
      showSnackbar("Failed to add timesheet", context);
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:
          isOtherUser
              ? Text(
                "Add Timesheet (${widget.email})",
                style: TextStyle(fontSize: 20.0),
              )
              : const Text("Add Timesheet"),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Date",
                      errorText: _dateError,
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(
                      _date == null
                          ? "Select a date"
                          : _date!.toIso8601String().split("T")[0],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _hoursController,
                  onChanged: (_) => setState(() => _hoursError = null),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Hours",
                    errorText: _hoursError,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24.0),
                _isSaving
                    ? const CircularProgressIndicator()
                    : FilledButton(
                      onPressed: _addTimesheet,
                      child: const Text("Add"),
                    ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
