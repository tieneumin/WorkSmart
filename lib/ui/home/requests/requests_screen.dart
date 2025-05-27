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

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    final res = await _repo.getRequests();
    if (!mounted) return;
    setState(() {
      _requests = res;
    });
  }

  void _navigateToAdd() async {
    var res = await context.pushNamed(Screen.addRequest.name);
    if (res == true) _refresh();
  }

  void _navigateToDetails(Request request) async {
    var res = await context.pushNamed(
      Screen.editRequest.name,
      pathParameters: {"id": request.id!.toString()},
    );
    if (res == true) _refresh();
  }

  // Future<void> _updateStatus(Request req, String status) async {
  //   // TODO: Update request status in backend
  //   // await RequestRepo().updateRequest(req.copy(status: status));
  //   setState(() {
  //     _requests =
  //         _requests
  //             .map((r) => r.id == req.id ? req.copy(status: status) : r)
  //             .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Requests")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _requests.length,
          itemBuilder:
              (context, index) => RequestItem(
                request: _requests[index],
                // onClickItem: (id) => _navigateToDetails(),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({
    super.key,
    required this.request,
    // required this.onClickItem,
  });
  final Request request;
  // final Function(int) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      // child: GestureDetector(
      //   onTap: () => onClickItem(request.id!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(request.title, style: Theme.of(context).textTheme.titleLarge),
          Text(request.status),
        ],
      ),
      // ),
    );
  }
}
