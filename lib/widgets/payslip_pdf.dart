import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

pw.Widget payslipPdf({
  required String email,
  required String role,
  required double salary,
  required Uint8List logo,
  required pw.Font regFont,
  required pw.Font boldFont,
}) {
  final now = DateTime.now();
  final monthYear = DateFormat.yMMMM().format(now);
  final date = DateFormat("yyyy-MM-dd hh:mm a").format(now);

  return pw.Padding(
    padding: const pw.EdgeInsets.all(16.0),
    child: pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "e-Payslip ($monthYear)",
                style: pw.TextStyle(font: boldFont, fontSize: 20.0),
              ),
            ),
            pw.Expanded(child: pw.Image(pw.MemoryImage(logo))),
          ],
        ),
        pw.SizedBox(height: 16.0),

        _labelValue("Email", email, regFont, boldFont),
        _labelValue("Role", role, regFont, boldFont),
        _labelValue(
          "Salary",
          "RM ${salary.toStringAsFixed(2)}",
          regFont,
          boldFont,
        ),
        _labelValue("Generated", date, regFont, boldFont),

        pw.SizedBox(height: 32.0),
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
    ),
  );
}

pw.Widget _labelValue(
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
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(value, style: pw.TextStyle(font: regFont, fontSize: 16.0)),
      ],
    ),
  );
}
