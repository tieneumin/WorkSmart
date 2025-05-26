import 'package:flutter/material.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:worksmart/service/storage_service.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _bodyController = TextEditingController();
  String? _attachmentPath;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    // TODO: Implement file picker and upload logic using StorageService
    // Example: final path = await StorageService().pickAndUploadFile();
    // setState(() => _attachmentPath = path);
  }

  Future<void> _submit() async {
    if (_bodyController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    // TODO: Save request to backend (add your repo/service logic here)
    // Example:
    // await RequestRepo().addRequest(Request(
    //   userId: ..., // get from auth
    //   body: _bodyController.text,
    //   attachment: _attachmentPath ?? '',
    // ));
    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Request details',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach File'),
                ),
                const SizedBox(width: 8),
                if (_attachmentPath != null)
                  Expanded(
                    child: Text(
                      _attachmentPath!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
