import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/data/model/timesheet.dart';
import 'package:worksmart/data/repo/timesheet_supabase.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/provider/user_provider.dart';

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

  late final String? _userId;
  DateTime? _selectedDate;

  @override
  void initState() {
    _userId = context.read<UserProvider>().user!.id;
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _addTimesheet() async {
    final hoursText = _hoursController.text;
    final date = _selectedDate;

    if (hoursText.isEmpty || date == null) {
      setState(() {
        if (hoursText.isEmpty) _hoursError = "Field is required";
        if (date == null) _dateError = "Date is required";
      });
      return;
    }
    final hours = double.tryParse(hoursText);
    if (hours == null || hours <= 0) {
      setState(() => _hoursError = "Enter a valid number of hours");
      return;
    }
    setState(() => _isLoading = true);
    try {
      // final timesheet = Timesheet(date: date, hours: hours);
      // await _repo.addTimesheet(timesheet);
      if (mounted) context.pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to add timesheet: $e")));
      }
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
                        ? "Select date"
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
