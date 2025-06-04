import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';

class EditTimesheetScreen extends StatefulWidget {
  const EditTimesheetScreen({super.key, required this.id, this.email});
  final String id;
  final String? email;

  @override
  State<EditTimesheetScreen> createState() => _EditTimesheetScreenState();
}

class _EditTimesheetScreenState extends State<EditTimesheetScreen> {
  final _repo = TimesheetSupabase();
  DateTime? _date;
  final _hoursController = TextEditingController();
  String? _dateError;
  String? _hoursError;
  Timesheet? _timesheet;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initTimesheet();
  }

  Future<void> _initTimesheet() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getTimesheetById(int.parse(widget.id));
      _timesheet = res;
      _date = res?.date;
      _hoursController.text = res?.hours.toString() ?? "";
      if (!mounted) return;
      setState(() => _isLoading = false);
    } on PostgrestException {
      showSnackbar("Failed to load timesheet details", context);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
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

  Future<void> _updateTimesheet() async {
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
      await _repo.updateTimesheet(_timesheet!.copy(date: _date, hours: hours));
      if (!mounted) return;
      showSnackbar("Timesheet updated", context, success: true);
      context.pop(true);
    } on PostgrestException {
      showSnackbar("Failed to update timesheet", context);
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
          widget.email != null
              ? Text(
                "Edit Timesheet (${widget.email})",
                style: TextStyle(fontSize: 20.0),
              )
              : const Text("Edit Timesheet"),
    ),
    body: SafeArea(
      child: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : _timesheet == null
                ? const Text("Timesheet not found")
                : SingleChildScrollView(
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
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
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
                              onPressed: _updateTimesheet,
                              child: const Text("Update"),
                            ),
                      ],
                    ),
                  ),
                ),
      ),
    ),
  );
}
