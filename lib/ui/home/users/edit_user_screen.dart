import 'package:flutter/material.dart';
import 'package:worksmart/data/repo/app_user_supabase.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/core/utils.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key, required this.id});
  final String id;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _repo = AppUserSupabase();
  AppUser? _user;
  final _salaryController = TextEditingController();
  String _role = "";
  String? _salaryError;
  String? _roleError;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    setState(() => _isLoading = true);
    try {
      final res = await _repo.getUserById(widget.id);
      if (!mounted) return;
      setState(() {
        _user = res;
        _salaryController.text = res?.salary.toStringAsFixed(2) ?? "";
        _role = res?.role ?? "";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        showSnackbar("Failed to load user", context);
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    final salaryText = _salaryController.text;
    final salary = double.tryParse(salaryText);

    if (salaryText.isEmpty || _role.isEmpty) {
      setState(() {
        if (salaryText.isEmpty) _salaryError = "Salary is required";
        if (_role.isEmpty) _roleError = "Role is required";
      });
      return;
    }
    if (salary == null || salary < 0) {
      setState(() => _salaryError = "Enter a valid salary");
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _repo.updateUser(_user!.copy(role: _role, salary: salary));
      if (!mounted) return;
      showSnackbar("User updated", context, error: false);
      context.pop(true);
    } catch (e) {
      showSnackbar("Failed to update user", context);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit User")),
      body: SafeArea(
        child: Center(
          child:
              _isLoading
                  ? const CircularProgressIndicator()
                  : _user == null
                  ? const Text("User not found")
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Email: ${_user!.email}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24.0),
                          TextField(
                            controller: _salaryController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged:
                                (_) => setState(() => _salaryError = null),
                            decoration: InputDecoration(
                              labelText: "Salary",
                              errorText: _salaryError,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField(
                            value: _role,
                            items: const [
                              DropdownMenuItem(
                                value: "",
                                child: Text("Select a role"),
                              ),
                              DropdownMenuItem(
                                value: "Employee",
                                child: Text("Employee"),
                              ),
                              DropdownMenuItem(value: "HR", child: Text("HR")),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _role = value);
                                if (value != "") {
                                  setState(() => _roleError = null);
                                }
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Role",
                              errorText: _roleError,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _isSaving
                              ? const CircularProgressIndicator()
                              : FilledButton(
                                onPressed: _updateUser,
                                child: const Text("Update"),
                              ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
