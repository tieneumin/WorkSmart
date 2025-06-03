import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/service/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
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
  String? _fileName;
  Uint8List? _bytes;
  bool _isSaving = false;

  String? _userId;

  @override
  void initState() {
    _userId = context.read<UserProvider>().user!.id;
    super.initState();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      _bytes = await file.readAsBytes();
      setState(() => _fileName = result.files.single.name);
    }
  }

  Future<void> _submitRequest() async {
    final title = _titleController.text;
    final body = _bodyController.text;

    if (title.isEmpty || body.isEmpty) {
      setState(() {
        if (title.isEmpty) _titleError = "Subject is required";
        if (body.isEmpty) _bodyError = "Details are required";
      });
      return;
    }

    setState(() => _isSaving = true);
    try {
      if (_fileName != null && _bytes != null) {
        await _storageService.uploadFile(_fileName!, _bytes!);
      }
      await _repo.addRequest(
        Request(userId: _userId!, title: title, body: body, file: _fileName),
      );
      if (!mounted) return;
      context.pop(true);
    } on PostgrestException catch (e) {
      showSnackbar(e.message, context);
    } finally {
      setState(() => _isSaving = false);
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
      appBar: AppBar(title: const Text("Submit Request")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    onChanged: (_) => setState(() => _titleError = null),
                    decoration: InputDecoration(
                      labelText: "Subject",
                      errorText: _titleError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _bodyController,
                    onChanged: (_) => setState(() => _bodyError = null),
                    maxLines: 5,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Details",
                      errorText: _bodyError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        label: const Text("Attach file"),
                        icon: const Icon(Icons.attach_file),
                      ),
                      if (_fileName != null)
                        Text(
                          _fileName!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  _isSaving
                      ? const CircularProgressIndicator()
                      : FilledButton(
                        onPressed: _submitRequest,
                        child: const Text("Submit"),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
