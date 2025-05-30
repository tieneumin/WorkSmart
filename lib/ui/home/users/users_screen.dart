import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

// only HR sees
class _UsersScreenState extends State<UsersScreen> {
  static final _repo = AppUserSupabase();
  var _users = <AppUser>[];
  late bool _isLoading;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    setState(() => _isLoading = true);
    final res = await _repo.getUsers();
    if (!mounted) return;
    setState(() {
      _users = res;
      _isLoading = false;
    });
  }

  void _navigateToAddUser() async {
    var res = await context.pushNamed(Screen.addUser.name);
    if (res == true) _refresh();
  }

  void _navigateToEditUser(String id) async {
    var res = await context.pushNamed(
      Screen.editUser.name,
      pathParameters: {"id": id},
    );
    if (res == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                ? const Center(child: Text("No users found"))
                : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder:
                      (context, index) => UserItem(
                        user: _users[index],
                        onClickItem: (user) => _navigateToEditUser(user.id),
                      ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddUser,
        child: Icon(Icons.add),
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user, required this.onClickItem});
  final AppUser user;
  final Function(AppUser) onClickItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onClickItem(user),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.email} (${user.role})",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Salary: RM${user.salary.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
