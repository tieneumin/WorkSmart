import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/service/storage_service.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _initRequest();
  }

  Future<void> _initRequest() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getRequestById(int.parse(widget.id));
      _request = res;
      if (!mounted) return;
      setState(() => _isLoading = false);
    } on PostgrestException {
      showSnackbar("Failed to load request details", context);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String status) async {
    try {
      await _repo.updateRequest(_request!.copy(status: status));
      if (!mounted) return;
      showSnackbar(
        "Request ${status.toLowerCase()}",
        context,
        success: status == "Approved",
      );
      context.pop(true);
    } on PostgrestException {
      showSnackbar("Failed to update request status", context);
    }
  }

  Future<void> _showAttachment(String file) async {
    final isImage =
        file.endsWith(".jpg") ||
        file.endsWith(".jpeg") ||
        file.endsWith(".png") ||
        file.endsWith(".gif") ||
        file.endsWith(".webp");
    final isPdf = file.endsWith(".pdf");

    if (isImage) {
      final url = _storageService.getFileUrl(file);
      showDialog(
        context: context,
        builder:
            (_) => Dialog(child: InteractiveViewer(child: Image.network(url))),
      );
    } else if (isPdf) {
      final bytes = await _storageService.getParsedFile(file);
      if (!mounted) return;
      if (bytes == null) {
        showSnackbar("Something went wrong", context);
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
    final currentUser = context.watch<UserProvider>().user;
    final isRequester = _request?.userId == currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _request == null
                ? const Center(child: Text("Request not found."))
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subject:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _request!.title,
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
                          "Details:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _request!.body,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        if (_request!.file != null) ...[
                          const Divider(height: 24.0),
                          Text(
                            "Attachment:",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          InkWell(
                            onTap: () => _showAttachment(_request!.file!),
                            child: Row(
                              children: [
                                const Icon(Icons.attachment),
                                const SizedBox(width: 12.0),
                                Text(
                                  _request!.file!,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // only HR can approve/reject
                        if (currentUser!.role == "HR") ...[
                          const SizedBox(height: 24.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  label: const Text("Approve"),
                                  icon: const Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[700],
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(48.0),
                                  ),
                                  onPressed:
                                      // HR cannot approve/reject own request
                                      isRequester ||
                                              _request!.status == "Approved"
                                          ? null
                                          : () => _updateStatus("Approved"),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: ElevatedButton.icon(
                                  label: const Text("Reject"),
                                  icon: const Icon(Icons.close),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[900],
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(48.0),
                                  ),
                                  onPressed:
                                      isRequester ||
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
      ),
    );
  }
}
