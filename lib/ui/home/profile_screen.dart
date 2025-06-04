import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:worksmart/data/model/app_user.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pp;
import 'package:worksmart/widgets/payslip_pdf.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';

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

  Future<void> _showPayslip(AppUser user) async {
    final pdfBytes = await _generatePayslip(user);
    final document = PdfDocument.openData(pdfBytes);
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PdfView(controller: PdfController(document: document)),
            ),
          ),
    );
  }

  Future<Uint8List> _generatePayslip(AppUser user) async {
    final logo = await rootBundle.load("assets/images/logo.png");
    final logoBytes = logo.buffer.asUint8List();
    final regFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSans-Bold.ttf"),
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: pp.PdfPageFormat.a5.landscape,
        build:
            (pw.Context context) => payslipPdf(
              user: user,
              logo: logoBytes,
              regFont: regFont,
              boldFont: boldFont,
            ),
      ),
    );
    return await pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;
    final avatarUrl = _authService.getCurrentUserAvatarUrl();

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
                          avatarUrl != null
                              ? CircleAvatar(
                                radius: 32.0,
                                backgroundImage: NetworkImage(avatarUrl),
                              )
                              : const CircleAvatar(
                                radius: 32.0,
                                child: Icon(Icons.account_circle),
                              ),
                          const SizedBox(height: 24.0),
                          Text(
                            "Email: ${currentUser.email}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Salary: RM ${currentUser.salary.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Role: ${currentUser.role}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton.icon(
                            onPressed: () => _showPayslip(currentUser),
                            label: const Text("Show monthly e-payslip"),
                            icon: const Icon(Icons.receipt_long_outlined),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48.0),
                            ),
                          ),
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
