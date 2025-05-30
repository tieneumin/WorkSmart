import 'package:flutter/material.dart';

class EditTimesheetScreen extends StatefulWidget {
  const EditTimesheetScreen({super.key, required this.id});
  final String id;

  @override
  State<EditTimesheetScreen> createState() => _EditTimesheetScreenState();
}

class _EditTimesheetScreenState extends State<EditTimesheetScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("EditTimesheet ${widget.id}");
  }
}
