import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:starelectricerp/core/pdf_fonts.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

class CustomerLedgerPdfGenerator {
  static Future<Uint8List> generate({
    required CustomerLedgerStatement statement,
  }) async {
    final theme = await PdfFontHelper.loadTheme();
    final pdf = pw.Document(theme: theme);

    final customer = statement.customer;
    final dateFmt = DateFormat('dd/MM/yyyy');

    final periodText = statement.isAllTime || statement.fromDate == null
        ? 'All Time (Up to ${dateFmt.format(statement.toDate)})'
        : '${dateFmt.format(statement.fromDate!)} to ${dateFmt.format(statement.toDate)}';

    final headers = <String>[
      'Date',
      'Document',
      'Debit',
      'Credit',
      'Running Balance',
    ];

    final data = <List<dynamic>>[];

    // Opening Balance row
    final openingDateStr = statement.fromDate != null
        ? dateFmt.format(statement.fromDate!)
        : '-';

    data.add([
      pw.Text(openingDateStr, style: const pw.TextStyle(fontSize: 8)),
      pw.Text('Opening Balance', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.Text('-', style: const pw.TextStyle(fontSize: 8)),
      pw.Text('-', style: const pw.TextStyle(fontSize: 8)),
      pw.Text(
        '₹${statement.openingBalance.toStringAsFixed(2)}',
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
    ]);

    // Rows for each transaction
    for (final entry in statement.entries) {
      data.add([
        pw.Text(
          dateFmt.format(entry.date),
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          entry.document,
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          entry.debit != null && entry.debit! > 0 ? '₹${entry.debit!.toStringAsFixed(2)}' : '-',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          entry.credit != null && entry.credit! > 0 ? '₹${entry.credit!.toStringAsFixed(2)}' : '-',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          '₹${entry.runningBalance.toStringAsFixed(2)}',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ]);
    }

    // Totals row
    data.add([
      pw.Text('', style: const pw.TextStyle(fontSize: 8)),
      pw.Text('Total for Period', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.Text(
        statement.totalDebit > 0 ? '₹${statement.totalDebit.toStringAsFixed(2)}' : '-',
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text(
        statement.totalCredit > 0 ? '₹${statement.totalCredit.toStringAsFixed(2)}' : '-',
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text('-', style: const pw.TextStyle(fontSize: 8)),
    ]);

    // Closing Balance row
    data.add([
      pw.Text('', style: const pw.TextStyle(fontSize: 8)),
      pw.Text(
        'Closing Balance (Net Outstanding)',
        style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.red800),
      ),
      pw.Text('', style: const pw.TextStyle(fontSize: 8)),
      pw.Text('', style: const pw.TextStyle(fontSize: 8)),
      pw.Text(
        '₹${statement.closingBalance.toStringAsFixed(2)}',
        style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.red800),
      ),
    ]);

    final columnWidths = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(65),
      1: const pw.FlexColumnWidth(3.0),
      2: const pw.FixedColumnWidth(80),
      3: const pw.FixedColumnWidth(80),
      4: const pw.FixedColumnWidth(90),
    };

    final alignments = <int, pw.Alignment>{
      0: pw.Alignment.center,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
    };

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.only(
            top: (InvoicePdfGenerator.letterheadTopMarginCm * PdfPageFormat.cm) + 16,
            left: 32,
            right: 32,
            bottom: 32,
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: pw.EdgeInsets.only(
                top: InvoicePdfGenerator.letterheadTopMarginCm * PdfPageFormat.cm,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 0.5),
              ),
            ),
          ),
        ),
        header: (context) {
          if (context.pageNumber > 1) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.only(bottom: 4),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'STATEMENT OF ACCOUNT - ${customer.name}',
                    style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    periodText,
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                  ),
                ],
              ),
            );
          }
          return pw.SizedBox();
        },
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 8),
          padding: const pw.EdgeInsets.only(top: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated on ${dateFmt.format(DateTime.now())} ${DateFormat('HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
              ),
            ],
          ),
        ),
        build: (context) => [
          // Centered Title
          pw.Center(
            child: pw.Text(
              'STATEMENT OF ACCOUNT',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          pw.SizedBox(height: 12),

          // Customer Header Info Block
          _buildCustomerHeader(customer, periodText),
          pw.SizedBox(height: 12),

          // Table with repeating header across pages
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            columnWidths: columnWidths,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
              fontSize: 8.5,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
            cellHeight: 20,
            cellAlignments: alignments,
            cellStyle: const pw.TextStyle(fontSize: 8),
          ),
          pw.SizedBox(height: 12),

          // Closing Summary Box
          _buildSummaryBox(statement),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildCustomerHeader(Customer customer, String periodText) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'To: ${customer.name}',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                if (customer.address.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    customer.address.trim(),
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
                if (customer.state.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'State: ${customer.state.trim()}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
                if (customer.phone.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Phone: ${customer.phone.trim()}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (customer.gstin != null && customer.gstin!.trim().isNotEmpty) ...[
                  pw.Text(
                    'GSTIN: ${customer.gstin!.trim()}',
                    style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 2),
                ],
                if (customer.panNumber != null && customer.panNumber!.trim().isNotEmpty) ...[
                  pw.Text(
                    'PAN: ${customer.panNumber!.trim()}',
                    style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 2),
                ],
                pw.Text(
                  'Statement Period:',
                  style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  periodText,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryBox(CustomerLedgerStatement statement) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 260,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.5),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
          color: PdfColors.grey100,
        ),
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Opening Balance:', style: const pw.TextStyle(fontSize: 8.5)),
                pw.Text('₹${statement.openingBalance.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
              ],
            ),
            pw.SizedBox(height: 3),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Billed (Debit):', style: const pw.TextStyle(fontSize: 8.5)),
                pw.Text('₹${statement.totalDebit.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
              ],
            ),
            pw.SizedBox(height: 3),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Paid (Credit):', style: const pw.TextStyle(fontSize: 8.5)),
                pw.Text('₹${statement.totalCredit.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
              ],
            ),
            pw.Divider(thickness: 0.5, color: PdfColors.grey400),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Closing Balance (Outstanding):',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '₹${statement.closingBalance.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.red800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
