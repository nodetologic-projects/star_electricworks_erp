import 'package:starelectricerp/core/date_formatting.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class InvoicePdfGenerator {
  static Future<Uint8List> generate({
    required CompanySetting company,
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Customer customer,
  }) async {
    final fontRegular = await PdfGoogleFonts.manropeRegular();
    final fontBold = await PdfGoogleFonts.manropeSemiBold();
    final fontItalic = await PdfGoogleFonts.manropeLight();
    final fontBoldItalic = await PdfGoogleFonts.manropeMedium();
    final monoFont = await PdfGoogleFonts.iBMPlexMonoRegular();
    final monoFontBold = await PdfGoogleFonts.iBMPlexMonoSemiBold();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
    );
    final pdf = pw.Document(theme: theme);
    
    // Load logo from assets
    final ByteData bytes = await rootBundle.load('assets/icon/app_icon.png');
    final pw.ImageProvider logoImage = pw.MemoryImage(bytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              margin: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 0.5)),
            ),
          ),
        ),
        build: (context) {
          final isPurchase = invoice.invoiceType == InvoiceType.purchaseVoucher;
          final isDeliveryChallan = invoice.invoiceType == InvoiceType.deliveryChallan;

          return [
            _buildHeader(company, logoImage, invoice.invoiceType),
            pw.SizedBox(height: 24),
            _buildMetaRow(invoice, isDeliveryChallan, items, monoFont, monoFontBold),
            if ((invoice.poNumber != null && invoice.poNumber!.isNotEmpty) || (invoice.gpNumber != null && invoice.gpNumber!.isNotEmpty)) ...[
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    if (invoice.poNumber != null && invoice.poNumber!.isNotEmpty) ...[
                      pw.Text('PO No: ', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                      pw.Text(invoice.poNumber!, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      if (invoice.poDate != null) ...[
                        pw.SizedBox(width: 16),
                        pw.Text('PO Date: ', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                        pw.Text(PdfDateFormatter.formatDate(invoice.poDate!), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ],
                    if (invoice.gpNumber != null && invoice.gpNumber!.isNotEmpty) ...[
                      if (invoice.poNumber != null && invoice.poNumber!.isNotEmpty)
                        pw.SizedBox(width: 16),
                      pw.Text('GP No: ', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                      pw.Text(invoice.gpNumber!, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ]
                  ],
                ),
              ),
            ],
            pw.SizedBox(height: 16),
            _buildBillTo(customer, isPurchase: isPurchase),
            
            if (isDeliveryChallan) ...[
              pw.SizedBox(height: 16),
              _buildDeliveryDetails(invoice, customer),
            ],

            pw.SizedBox(height: 24),
            _buildBody(invoice.invoiceType, items, invoice, monoFont),
            pw.SizedBox(height: 16),
            
            if (!isDeliveryChallan) ...[
              _buildTotalsRow(invoice, monoFont, monoFontBold),
              pw.SizedBox(height: 24),
              pw.Text(
                'Amount in Words: ${invoice.amountInWords}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic),
              ),
            ],


            if (invoice.paymentTermDays != null) ...[
              pw.SizedBox(height: 12),
              pw.Text(
                'Payment Terms: Pay within ${invoice.paymentTermDays} days of bill generation',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.black),
              ),
            ],

            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Notes:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    pw.SizedBox(height: 4),
                    pw.Text(invoice.notes!, style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  ],
                ),
              ),
            ],

            pw.SizedBox(height: 32),
            _buildFooter(company, invoice),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(CompanySetting company, pw.ImageProvider? logoImage, InvoiceType type) {
    String typeLabel = 'INVOICE';
    switch (type) {
      case InvoiceType.serviceTaxInvoice:
        typeLabel = 'TAX INVOICE — SERVICES';
        break;
      case InvoiceType.salesTaxInvoice:
        typeLabel = 'TAX INVOICE';
        break;
      case InvoiceType.billOfSupply:
        typeLabel = 'BILL OF SUPPLY';
        break;
      case InvoiceType.purchaseVoucher:
        typeLabel = 'PURCHASE VOUCHER';
        break;
      case InvoiceType.deliveryChallan:
        typeLabel = 'DELIVERY CHALLAN';
        break;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              if (logoImage != null) ...[
                pw.Image(logoImage, width: 60, height: 60),
                pw.SizedBox(width: 16),
              ],
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(company.companyName, style: pw.TextStyle(color: PdfColors.black, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(company.address, style: const pw.TextStyle(color: PdfColors.black, fontSize: 10)),
                  pw.Text('Phone: ${company.phone}', style: const pw.TextStyle(color: PdfColors.black, fontSize: 10)),
                  pw.Text('GSTIN: ${company.gstin}', style: pw.TextStyle(color: PdfColors.black, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
          pw.Text(
            typeLabel,
            style: pw.TextStyle(color: PdfColor.fromHex('#501817'), fontSize: 16, fontWeight: pw.FontWeight.bold, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMetaRow(Invoice invoice, bool isDeliveryChallan, List<InvoiceItem> items, pw.Font monoFont, pw.Font monoFontBold) {
    
    String? motorJobSummary;
    if (isDeliveryChallan && items.isNotEmpty) {
      motorJobSummary = items.map((i) => i.description).join(", ");
    }

    pw.Widget buildMetaCol(String label, String value, {bool bold = false}) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.black, fontSize: 10)),
          pw.SizedBox(height: 2),
          pw.Text(value, style: pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 14, font: bold ? monoFontBold : monoFont)),
        ],
      );
    }

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        buildMetaCol(isDeliveryChallan ? 'Challan Number' : 'Invoice Number', invoice.invoiceNo, bold: true),
        buildMetaCol('Date', PdfDateFormatter.formatDate(invoice.invoiceDate), bold: true),
        if (!isDeliveryChallan)
          buildMetaCol('Due Date', invoice.dueDate != null ? PdfDateFormatter.formatDate(invoice.dueDate!) : 'N/A', bold: true),
        if (isDeliveryChallan && motorJobSummary != null)
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Motor Job Reference', style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.Text(motorJobSummary, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold), maxLines: 2, textAlign: pw.TextAlign.right),
                ],
              ),
            ),
          )
      ],
    );
  }

  static pw.Widget _buildBillTo(Customer customer, {bool isPurchase = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(isPurchase ? 'Purchased From:' : 'Bill To:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
        pw.SizedBox(height: 4),
        pw.Text(customer.name, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Text(customer.address, style: const pw.TextStyle(fontSize: 10)),
        if (customer.gstin != null && customer.gstin!.isNotEmpty)
          pw.Text('GSTIN: ${customer.gstin}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildDeliveryDetails(Invoice invoice, Customer customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Dispatch Date:', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
              pw.Text(PdfDateFormatter.formatDate(invoice.invoiceDate), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Delivery Address:', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
              pw.Text(customer.address, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Delivery Charge:', style: pw.TextStyle(fontSize: 10, color: PdfColors.black)),
              pw.Text(invoice.deliveryCharge != null ? '₹${invoice.deliveryCharge?.toStringAsFixed(2)}' : 'N/A', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      )
    );
  }

  static pw.Widget _buildBody(InvoiceType type, List<InvoiceItem> items, Invoice invoice, pw.Font monoFont) {
    switch (type) {
      case InvoiceType.serviceTaxInvoice:
        return _buildServiceTable(items, monoFont);
      case InvoiceType.salesTaxInvoice:
        return _buildStandardTable(items, showGst: true, monoFont: monoFont);
      case InvoiceType.billOfSupply:
        return _buildStandardTable(items, showGst: false, monoFont: monoFont);
      case InvoiceType.purchaseVoucher:
        return _buildStandardTable(items, showGst: true, isPurchase: true, monoFont: monoFont);
      case InvoiceType.deliveryChallan:
        return _buildStandardTable(items, showGst: false, isDeliveryChallan: true, monoFont: monoFont);
    }
  }

  static pw.Widget _buildServiceTable(List<InvoiceItem> items, pw.Font monoFont) {
    final headers = ['Service Description', 'SAC', 'Amount'];
    final data = items.map((item) {
      return [
        item.description,
        item.hsnCode ?? '',
        pw.Text(item.lineTotal.toStringAsFixed(2), style: pw.TextStyle(font: monoFont)),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black),
      headerDecoration: null,
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildStandardTable(List<InvoiceItem> items, {required bool showGst, bool isPurchase = false, bool isDeliveryChallan = false, required pw.Font monoFont}) {
    final headers = [
      'Description',
      if (!isDeliveryChallan) 'HSN/SAC',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      'Total'
    ];

    final data = items.map((item) {
      return [
        item.description,
        if (!isDeliveryChallan) item.hsnCode ?? '',
        pw.Text(item.qty?.toString() ?? '1', style: pw.TextStyle(font: monoFont)),
        pw.Text(item.unitPrice.toStringAsFixed(2), style: pw.TextStyle(font: monoFont)),
        if (showGst) pw.Text('${item.gstRate ?? 0}%', style: pw.TextStyle(font: monoFont)),
        pw.Text(item.lineTotal.toStringAsFixed(2), style: pw.TextStyle(font: monoFont)),
      ];
    }).toList();

    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
    };
    
    if (isDeliveryChallan) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      };
    } else if (!showGst) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      };
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black),
      headerDecoration: null,
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellHeight: 30,
      cellAlignments: alignments,
    );
  }

  static pw.Widget _buildTotalsRow(Invoice invoice, pw.Font monoFont, pw.Font monoFontBold) {
    final bool isBillOfSupply = invoice.invoiceType == InvoiceType.billOfSupply;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 250,
          child: pw.Column(
            children: [
              _buildTotalsLine('Subtotal:', invoice.subtotal, monoFont, monoFontBold),
              if (invoice.discountAmount > 0)
                _buildTotalsLine('Discount:', -invoice.discountAmount, monoFont, monoFontBold),
              
              // Only show delivery charge here if it's not a delivery challan
              if (invoice.invoiceType != InvoiceType.deliveryChallan && invoice.deliveryCharge != null && invoice.deliveryCharge! > 0)
                _buildTotalsLine('Delivery Charge:', invoice.deliveryCharge!, monoFont, monoFontBold),
              
              if (!isBillOfSupply && (invoice.cgstAmount > 0 || invoice.sgstAmount > 0 || invoice.igstAmount > 0)) ...[
                _buildTotalsLine('IGST:', invoice.igstAmount, monoFont, monoFontBold),
                _buildTotalsLine('CGST:', invoice.cgstAmount, monoFont, monoFontBold),
                _buildTotalsLine('SGST:', invoice.sgstAmount, monoFont, monoFontBold),
              ],
              pw.Divider(),
              _buildTotalsLine('Grand Total:', invoice.grandTotal, monoFont, monoFontBold, isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalsLine(String label, double amount, pw.Font monoFont, pw.Font monoFontBold, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(amount.toStringAsFixed(2), style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, font: isBold ? monoFontBold : monoFont)),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(CompanySetting company, Invoice invoice) {
    final type = invoice.invoiceType;
    final isPurchase = type == InvoiceType.purchaseVoucher;
    final isDeliveryChallan = type == InvoiceType.deliveryChallan;
    final isBillOfSupply = type == InvoiceType.billOfSupply;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (!isPurchase && !isDeliveryChallan) ...[
                pw.Text('Bank Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text('Bank Name: ${company.bankName}', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Account No: ${company.bankAccountNo}', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('IFSC: ${company.bankIfsc}', style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 16),
              ],
              if (isBillOfSupply)
                pw.Text('This is a Bill of Supply — no GST is charged on this transaction.', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
              
              if (!isDeliveryChallan && !isPurchase)
                pw.Text('Thank you for your business.', style: const pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.black)),

              if (isDeliveryChallan) ...[
                // E-way bill placeholder area
                pw.Container(
                  width: 100,
                  height: 100,
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, style: pw.BorderStyle.dashed)),
                  child: pw.Center(child: pw.Text('e-Way Bill QR\n(Placeholder)', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black))),
                )
              ]
            ],
          ),
        ),
        
        if (invoice.requiresEInvoice)
          pw.Container(
            width: 80,
            height: 80,
            margin: const pw.EdgeInsets.only(right: 16),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, style: pw.BorderStyle.dashed)),
            child: pw.Center(child: pw.Text('IRN QR\n(Placeholder)', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black))),
          ),

        if (isDeliveryChallan)
          pw.Container(
            width: 150,
            margin: const pw.EdgeInsets.only(right: 32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 40),
                pw.Divider(thickness: 1),
                pw.Text('Received in good condition', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text('(Customer Sign)', style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
              ],
            ),
          ),

        if (!isPurchase)
          pw.Container(
            width: 150,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 40), // Space for signature
                pw.Divider(thickness: 1),
                pw.Text('Authorized Signatory', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
      ],
    );
  }
}
