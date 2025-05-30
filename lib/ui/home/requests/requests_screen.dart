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

// filter by user if employee; no filter for HR
class _RequestsScreenState extends State<RequestsScreen> {
  static final _repo = RequestSupabase();
  var _requests = <Request>[];
  late bool _isLoading;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    setState(() => _isLoading = true);
    final res = await _repo.getRequests();
    if (!mounted) return;
    setState(() {
      _requests = res;
      _isLoading = false;
    });
  }

  void _navigateToAddRequest() async {
    var res = await context.pushNamed(Screen.addRequest.name);
    if (res == true) _refresh();
  }

  void _navigateToRequestDetails(int id) async {
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
                : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder:
                      (context, index) => RequestItem(
                        request: _requests[index],
                        onClickItem:
                            (request) => _navigateToRequestDetails(request.id!),
                      ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRequest,
        child: Icon(Icons.add),
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
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onClickItem(request),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              "Status: ${request.status}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
