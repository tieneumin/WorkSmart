import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:worksmart/data/model/app_user.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

pw.Widget payslipPdf({
  required AppUser user,
  required Uint8List logo,
  required pw.Font regFont,
  required pw.Font boldFont,
}) {
  final now = DateTime.now();
  final monthYear = DateFormat.yMMMM().format(now);
  final date = DateFormat("yyyy-MM-dd hh:mm a").format(now);

  return pw.Column(
    children: [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "e-Payslip ($monthYear)",
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 20.0,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
          pw.Expanded(child: pw.Image(pw.MemoryImage(logo))),
        ],
      ),
      _labelledText("Email", user.email, regFont, boldFont),
      _labelledText("Role", user.role, regFont, boldFont),
      _labelledText(
        "Salary",
        "RM ${user.salary.toStringAsFixed(2)}",
        regFont,
        boldFont,
      ),
      _labelledText("Generated", date, regFont, boldFont),
      pw.SizedBox(height: 64.0),
      pw.Text(
        "This document is computer-generated and does not require a signature.\n"
        "Salary is subject to the applicable deductions and may vary by month.\n"
        "Please contact HR in the event of a discrepancy.\n",
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          font: regFont,
          fontSize: 12.0,
          color: PdfColors.grey,
        ),
      ),
    ],
  );
}

pw.Widget _labelledText(
  String label,
  String value,
  pw.Font regFont,
  pw.Font boldFont,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
    child: pw.Row(
      children: [
        pw.Text(
          "$label: ",
          style: pw.TextStyle(font: boldFont, fontSize: 16.0),
        ),
        pw.Text(value, style: pw.TextStyle(font: regFont, fontSize: 16.0)),
      ],
    ),
  );
}
