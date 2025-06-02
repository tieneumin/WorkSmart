import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/service/storage_service.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:worksmart/core/utils.dart';
import 'package:pdfx/pdfx.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final _repo = RequestSupabase();
  final _storageService = StorageService();
  Request? _request;
  bool _isLoading = true;
  bool _isError = false;

  AppUser? _currentUser;

  @override
  void initState() {
    _currentUser = context.read<UserProvider>().user;
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getRequestById(int.parse(widget.id));
      if (!mounted) return;
      setState(() {
        _request = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String status) async {
    final updated = _request!.copy(status: status);
    try {
      await _repo.updateRequest(updated);
      if (!mounted) return;
      showSnackbar(
        "Request ${status.toLowerCase()}",
        context,
        error: status == "Rejected",
      );
      context.pop(true);
    } catch (e) {
      if (mounted) showSnackbar("Failed to update status", context);
    }
  }

  Future<void> _showAttachment(String file) async {
    final isImage =
        file.endsWith(".jpg") ||
        file.endsWith(".jpeg") ||
        file.endsWith(".png") ||
        file.endsWith(".svg") ||
        file.endsWith(".webp");
    final isPdf = file.endsWith(".pdf");

    if (isImage) {
      final url = _storageService.getFileUrl(file);
      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              child: InteractiveViewer(
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
      );
    } else if (isPdf) {
      final bytes = await _storageService.getParsedFile(file);
      if (!mounted) return;
      if (bytes == null) {
        showSnackbar("Failed to load PDF", context);
        return;
      }
      final document = PdfDocument.openData(bytes);
      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              child: PdfView(controller: PdfController(document: document)),
            ),
      );
    } else {
      showSnackbar("File type not supported", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isError == true
                ? Center(child: Text("Failed to load request"))
                : _request == null
                ? const Center(child: Text("Request not found."))
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        "Subject: ${_request!.title}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "By: ${_request!.email}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Submitted: ${_request!.createdAt.toString().split(".")[0]}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Status: ${_request!.status}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(height: 24.0),
                      Text(
                        "Details:\n${_request!.body}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Divider(height: 24.0),

                      if (_request!.file != null) ...[
                        Text(
                          "Attachment:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => _showAttachment(_request!.file!),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 8.0),
                              Text(
                                _request!.file!,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],

                      // only HR can approve/reject
                      if (_currentUser!.role == "HR") ...[
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text("Approve"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(48.0),
                                ),
                                onPressed:
                                    // HR cannot approve/reject own request
                                    _request!.userId == _currentUser!.id ||
                                            _request!.status == "Approved"
                                        ? null
                                        : () => _updateStatus("Approved"),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.close),
                                label: const Text("Reject"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(48.0),
                                ),
                                onPressed:
                                    _request!.userId == _currentUser!.id ||
                                            _request!.status == "Rejected"
                                        ? null
                                        : () => _updateStatus("Rejected"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
      ),
    );
  }
}
