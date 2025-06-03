import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:open_file/open_file.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    _authService.listenForSignOut(context);
    super.initState();
  }

  // Future<void> _downloadReceipt() async {
  //   final user = context.read<UserProvider>().user;
  //   if (user == null) return;
  //   final now = DateTime.now();
  //   final month = DateFormat('MMMM').format(now);
  //   final dateStr = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) => pw.Column(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           pw.Text('Salary Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
  //           pw.SizedBox(height: 16),
  //           pw.Text('Email: \\${user.email}'),
  //           pw.Text('Role: \\${user.role}'),
  //           pw.Text('Salary: RM\\${user.salary.toStringAsFixed(2)}'),
  //           pw.Text('Month: \\${month}'),
  //           pw.Text('Downloaded: \\${dateStr}'),
  //         ],
  //       ),
  //     ),
  //   );
  //   final output = await getTemporaryDirectory();
  //   final file = File("${output.path}/salary_receipt_\\${user.email}_\\${now.millisecondsSinceEpoch}.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   await OpenFile.open(file.path);
  // }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: Center(
          child:
              currentUser == null
                  ? const Text("No user data")
                  : Card(
                    elevation: 4.0,
                    color: Colors.white,
                    margin: const EdgeInsets.all(24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_circle, size: 64.0),
                          const SizedBox(height: 16.0),
                          Text(
                            "Email: ${currentUser.email}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Salary: RM${currentUser.salary.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Role: ${currentUser.role}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 24.0),
                          // ElevatedButton.icon(
                          //   onPressed: _downloadReceipt,
                          //   label: const Text("Download Salary Receipt"),
                          //   icon: const Icon(Icons.download),
                          //   style: FilledButton.styleFrom(
                          //     minimumSize: const Size.fromHeight(48.0),
                          //   ),
                          // ),
                          const SizedBox(height: 16.0),
                          FilledButton.icon(
                            onPressed: _authService.signOut,
                            label: const Text("Log Out"),
                            icon: const Icon(Icons.logout),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48.0),
                            ),
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
