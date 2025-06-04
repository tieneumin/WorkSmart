import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:worksmart/core/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _repo = AppUserSupabase();
  var _users = <AppUser>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getUsers();
      if (!mounted) return;
      setState(() {
        _users = res;
        _isLoading = false;
      });
    } catch (e) {
      showSnackbar("Failed to load users", context);
      _isLoading = false;
    }
  }

  Future<void> _navigateToAddUser() async {
    var res = await context.pushNamed(Screen.addUser.name);
    if (res == true) _refresh();
  }

  Future<void> _navigateToUserTimesheets(AppUser user) async {
    await context.pushNamed(
      Screen.userTimesheets.name,
      pathParameters: {"id": user.id},
      queryParameters: {"email": user.email},
    );
  }

  Future<void> _navigateToEditUser(String id) async {
    var res = await context.pushNamed(
      Screen.editUser.name,
      pathParameters: {"id": id},
    );
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                ? const Center(child: Text("No users found"))
                : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _users.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 4.0),
                    itemBuilder:
                        (context, index) => UserItem(
                          user: _users[index],
                          currentUser: currentUser,
                          onClickDetails:
                              (user) => _navigateToUserTimesheets(user),
                          onClickEdit: (user) => _navigateToEditUser(user.id),
                        ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddUser,
        icon: const Icon(Icons.add),
        label: const Text("Create User"),
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.currentUser,
    required this.onClickDetails,
    required this.onClickEdit,
  });
  final AppUser user;
  final AppUser? currentUser;
  final Function(AppUser) onClickDetails;
  final Function(AppUser) onClickEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: user.id != currentUser?.id ? Colors.white : Colors.blueGrey[50],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        title: Text(
          "${user.email} (${user.role})",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Salary: RM ${user.salary.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 4.0),
            Text(
              "Created: ${user.createdAt.toString().split(".")[0]}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HR cannot change own salary/role
            if (user.id != currentUser?.id) ...[
              IconButton(
                icon: const Icon(Icons.punch_clock),
                tooltip: "View Timesheets",
                onPressed: () => onClickDetails(user),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[700]),
                tooltip: "Edit",
                onPressed: () => onClickEdit(user),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
