import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/core/date_formatting.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

class QuotationPdfGenerator {
  static Future<Uint8List> generate({
    required CompanySetting company,
    required QuotationWithCustomer data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.only(
          top: InvoicePdfGenerator.letterheadTopMarginCm * PdfPageFormat.cm,
          bottom: 32,
          left: 32,
          right: 32,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'QUOTATION',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#501817'),
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data.quotation.quoteNo,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date: ${PdfDateFormatter.formatDate(data.quotation.createdAt)}'),
                  if (data.quotation.validUntil != null)
                    pw.Text(
                      'Valid Until: ${PdfDateFormatter.formatDate(data.quotation.validUntil!)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red700,
                      ),
                    ),
                ],
              ),
              pw.SizedBox(height: 24),
              
              // Disclaimer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Text(
                  'NOT A TAX INVOICE — PRICES SUBJECT TO CONFIRMATION',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, letterSpacing: 1),
                ),
              ),
              pw.SizedBox(height: 24),

              // Customer Info
              pw.Text('To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              if (data.customer != null) ...[
                pw.Text(data.customer!.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(data.customer!.address),
                pw.Text('Phone: ${data.customer!.phone}'),
              ] else ...[
                pw.Text(data.quotation.prospectiveCustomerName ?? 'Unknown', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                if (data.quotation.prospectiveCustomerPhone != null) pw.Text('Phone: ${data.quotation.prospectiveCustomerPhone!}'),
              ],
              pw.SizedBox(height: 32),

              // Description and Amount
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Estimated Amount (INR)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(data.quotation.description),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          data.quotation.estimatedAmount.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              pw.Spacer(),
              
              // Footer signature
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 40),
                      pw.Text('For ${company.companyName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text('Authorized Signatory'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
