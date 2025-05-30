import 'package:flutter/material.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';

class AddTimesheetScreen extends StatefulWidget {
  const AddTimesheetScreen({super.key});

  @override
  State<AddTimesheetScreen> createState() => _AddTimesheetScreenState();
}

class _AddTimesheetScreenState extends State<AddTimesheetScreen> {
  final _repo = TimesheetSupabase();
  final _hoursController = TextEditingController();
  String? _hoursError;
  String? _dateError;
  bool _isLoading = false;

  late String _userId;
  DateTime? _selectedDate;

  @override
  void initState() {
    _userId = context.read<UserProvider>().user!.id;
    super.initState();
  }

  Future<void> _pickDate() async {
    setState(() => _dateError = null);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month - 1),
      lastDate: now,
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _addTimesheet() async {
    final hoursText = _hoursController.text;
    final date = _selectedDate;

    if (date == null || hoursText.isEmpty) {
      setState(() {
        if (date == null) _dateError = "Date is required";
        if (hoursText.isEmpty) _hoursError = "Hours are required";
      });
      return;
    }
    final hours = double.tryParse(hoursText);
    if (hours == null || hours < 0 || hours > 24) {
      setState(() => _hoursError = "Enter a valid number of hours");
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _repo.addTimesheet(
        Timesheet(userId: _userId, hours: hours, date: date),
      );
      if (mounted) context.pop(true);
    } on PostgrestException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Timesheet")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    _selectedDate == null
                        ? "Select a date"
                        : _selectedDate!.toIso8601String().split("T")[0],
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                    onPressed: _addTimesheet,
                    child: const Text("Add"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
