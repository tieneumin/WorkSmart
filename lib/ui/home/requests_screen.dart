import 'package:flutter/material.dart';
import 'package:worksmart/data/model/request.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Request> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    // TODO: Fetch requests from backend (add your repo/service logic here)
    // Example:
    // final requests = await RequestRepo().getAllRequests();
    // requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // setState(() { _requests = requests; _isLoading = false; });
    setState(() => _isLoading = false);
  }

  Future<void> _updateStatus(Request req, String status) async {
    // TODO: Update request status in backend
    // await RequestRepo().updateRequest(req.copy(status: status));
    setState(() {
      _requests =
          _requests
              .map((r) => r.id == req.id ? req.copy(status: status) : r)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: _requests.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final req = _requests[i];
                  return ListTile(
                    title: Text(req.body),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${req.status}'),
                        Text('Created: ${req.createdAt}'),
                        if (req.attachment.isNotEmpty)
                          Text(
                            'Attachment: ${req.attachment}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed:
                              req.status == 'pending'
                                  ? () => _updateStatus(req, 'approved')
                                  : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed:
                              req.status == 'pending'
                                  ? () => _updateStatus(req, 'rejected')
                                  : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
