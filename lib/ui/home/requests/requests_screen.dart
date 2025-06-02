import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _repo = RequestSupabase();
  var _requests = <Request>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    final res = await _repo.getRequests();
    if (!mounted) return;
    setState(() {
      _requests = res;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAddRequest() async {
    var res = await context.pushNamed(Screen.addRequest.name);
    if (res == true) _refresh();
  }

  Future<void> _navigateToRequestDetails(int id) async {
    var res = await context.pushNamed(
      Screen.requestDetails.name,
      pathParameters: {"id": id.toString()},
    );
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Requests")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _requests.isEmpty
                ? const Center(child: Text("No requests submitted"))
                : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _requests.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 4.0),
                    itemBuilder:
                        (context, index) => RequestItem(
                          request: _requests[index],
                          onClickItem:
                              (request) =>
                                  _navigateToRequestDetails(request.id!),
                        ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddRequest,
        icon: const Icon(Icons.add),
        label: const Text("Submit Request"),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({
    super.key,
    required this.request,
    required this.onClickItem,
  });
  final Request request;
  final Function(Request) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () => onClickItem(request),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${request.status} — ${request.title}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "By: ${request.email}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4.0),
              Text(
                "Submitted: ${request.createdAt.toString().split(".")[0]}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
