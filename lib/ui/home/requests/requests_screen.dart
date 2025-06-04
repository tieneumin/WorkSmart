import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/data/repo/request_supabase.dart';
import 'package:worksmart/data/model/request.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:worksmart/core/utils.dart';
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

  bool _initProvider = false;
  AppUser? _user;

  DateTimeRange? _dateRange;
  var _filteredRequests = <Request>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initProvider) return;
    final currentUser = context.watch<UserProvider>().user;
    if (currentUser != null) {
      _user = currentUser;
      _refresh();
      _initProvider = true;
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    try {
      final res =
          _user!.role == "HR"
              ? await _repo.getRequests()
              : await _repo.getRequests(userId: _user!.id);
      _requests = res;
      _isLoading = false;
      if (!mounted) return;
      _applyFilter();
    } on PostgrestException {
      showSnackbar("Failed to load requests", context);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      _dateRange = DateTimeRange(
        start: DateTime.utc(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        ),
        end: DateTime.utc(picked.end.year, picked.end.month, picked.end.day),
      );
      _applyFilter();
    }
  }

  void _applyFilter() {
    if (_dateRange == null) {
      _filteredRequests = _requests;
    } else {
      _filteredRequests =
          _requests
              .where(
                (request) =>
                    request.createdAt.compareTo(_dateRange!.start) >= 0 &&
                    request.createdAt.compareTo(
                          _dateRange!.end.add(const Duration(days: 1)),
                        ) <
                        0,
              )
              .toList();
    }
    setState(() {});
  }

  Future<void> _navigateToAddRequest() async {
    final res = await context.pushNamed(Screen.addRequest.name);
    if (res == true) _refresh();
  }

  Future<void> _navigateToRequestDetails(int id) async {
    final res = await context.pushNamed(
      Screen.requestDetails.name,
      pathParameters: {"id": id.toString()},
    );
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Requests"),
      actions: [
        IconButton(
          onPressed: _pickDateRange,
          tooltip: "Filter by date",
          icon: const Icon(Icons.filter_alt),
        ),
        if (_dateRange != null)
          IconButton(
            onPressed: () {
              _dateRange = null;
              _applyFilter();
            },
            tooltip: "Clear filter",
            icon: const Icon(Icons.close),
          ),
      ],
    ),
    body: SafeArea(
      child:
          _isLoading || _user == null
              ? const Center(child: CircularProgressIndicator())
              : _dateRange == null && _filteredRequests.isEmpty
              ? const Center(child: Text("No requests submitted"))
              : _filteredRequests.isEmpty
              ? const Center(child: Text("No requests found"))
              : RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _filteredRequests.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 4.0),
                  itemBuilder:
                      (context, index) => RequestItem(
                        request: _filteredRequests[index],
                        onClickItem: (id) => _navigateToRequestDetails(id),
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

class RequestItem extends StatelessWidget {
  const RequestItem({
    super.key,
    required this.request,
    required this.onClickItem,
  });
  final Request request;
  final Function(int) onClickItem;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2.0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: InkWell(
      onTap: () => onClickItem(request.id!),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${request.status} — ${request.title}",
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
