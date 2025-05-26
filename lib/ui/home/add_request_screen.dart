import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/provider/user_id_provider.dart';
import 'package:worksmart/service/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _repo = RequestSupabase();
  final _storageService = StorageService();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String? _titleError;
  String? _bodyError;
  late final String? _userId;
  String? _fileName;
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _userId = context.watch<UserIdProvider>().userId;
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      _bytes = await file.readAsBytes();
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  void _submitRequest() async {
    final title = _titleController.text;
    final body = _bodyController.text;

    if (title.isEmpty || body.isEmpty) {
      setState(() {
        if (title.isEmpty) _titleError = "Title is required";
        if (body.isEmpty) _bodyError = "Details are required";
      });
      return;
    }

    try {
      if (_fileName != null && _bytes != null) {
        await _storageService.uploadFile(_fileName!, _bytes!);
      }
      await _repo.addRequest(
        Request(
          userId: _userId!,
          title: title,
          body: body,
          file: _fileName ?? "",
        ),
      );
      // if (!mounted) return;
      // context.pop(true);
    } on PostgrestException catch (e) {
      if (mounted) showErrorSnackbar(e.message, context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Request")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                onChanged: (_) => setState(() => _titleError = null),
                decoration: InputDecoration(
                  labelText: "Title",
                  errorText: _titleError,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _bodyController,
                onChanged: (_) => setState(() => _bodyError = null),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Details",
                  errorText: _bodyError,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    label: const Text("Attach file"),
                    icon: const Icon(Icons.attach_file),
                  ),
                  const SizedBox(width: 16.0),
                  if (_fileName != null)
                    Expanded(
                      child: Text(_fileName!, overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              FilledButton(onPressed: _submitRequest, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
