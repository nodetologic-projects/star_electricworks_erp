import 'package:starelectricerp/core/date_formatting.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:printing/printing.dart';

class InvoicePdfGenerator {
  static const double letterheadTopMarginCm = 5.0;

  static Future<Uint8List> generate({
    List<String> copyLabels = const ['Original for Recipient'],
    required CompanySetting company,
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Customer customer,
    double totalPaid = 0.0,
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

    final ByteData bytes = await rootBundle.load('assets/icon/app_icon.png');
    final pw.ImageProvider logoImage = pw.MemoryImage(
      bytes.buffer.asUint8List(),
    );

    for (final copyLabel in copyLabels) {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.only(
              top: (letterheadTopMarginCm * PdfPageFormat.cm) + 16,
              left: 32,
              right: 32,
              bottom: 32,
            ),
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                margin: pw.EdgeInsets.only(
                  top: letterheadTopMarginCm * PdfPageFormat.cm,
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
          build: (context) {
            final isPurchase =
                invoice.invoiceType == InvoiceType.purchaseVoucher;
            final isDeliveryChallan =
                invoice.invoiceType == InvoiceType.deliveryChallan;

            return [
              _buildHeaderBlock(
                company,
                logoImage,
                invoice,
                customer,
                isPurchase,
                copyLabel,
              ),

              pw.SizedBox(height: 10),
              _buildMetaRow(
                invoice,
                isDeliveryChallan,
                items,
                monoFont,
                monoFontBold,
              ),

              if (isDeliveryChallan) ...[
                pw.SizedBox(height: 10),
                _buildDeliveryDetails(invoice, customer),
              ],

              pw.SizedBox(height: 10),
              _buildBody(invoice.invoiceType, items, invoice, monoFont),
              pw.SizedBox(height: 10),

              if (!isDeliveryChallan) ...[
                _buildTotalsRow(
                  invoice,
                  items,
                  totalPaid,
                  monoFont,
                  monoFontBold,
                ),
              ],

              if (invoice.paymentTermDays != null) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  'Payment Terms: Pay within ${invoice.paymentTermDays} days of bill generation',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                    color: PdfColors.black,
                  ),
                ),
              ],

              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Notes:',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        invoice.notes!,
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              pw.SizedBox(height: 24),
              _buildFooter(company, invoice, totalPaid),
            ];
          },
        ),
      );
    }

    return pdf.save();
  }

  static pw.Widget _buildHeaderBlock(
    CompanySetting company,
    pw.ImageProvider? logoImage,
    Invoice invoice,
    Customer customer,
    bool isPurchase,
    String copyLabel,
  ) {
    String typeLabel = 'INVOICE';
    switch (invoice.invoiceType) {
      case InvoiceType.serviceTaxInvoice:
        typeLabel = 'TAX INVOICE';
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

    final shipToName =
        (invoice.shipToName != null && invoice.shipToName!.isNotEmpty)
        ? invoice.shipToName!
        : customer.name;
    final shipToAddress =
        (invoice.shipToAddress != null && invoice.shipToAddress!.isNotEmpty)
        ? invoice.shipToAddress!
        : customer.address;

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              copyLabel,
              style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
            ),
            pw.Text(
              '$typeLabel ${invoice.invoiceNo}',
              style: pw.TextStyle(
                color: PdfColor.fromHex('#501817'),
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left: Bill To
            pw.Expanded(
              child: pw.Container(
                height: 140,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      isPurchase ? 'Purchased From:' : 'Bill To:',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      customer.name,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      customer.address,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    if (customer.gstin != null && customer.gstin!.isNotEmpty)
                      pw.Text(
                        'GSTIN: ${customer.gstin}',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (customer.vendorCode != null &&
                        customer.vendorCode!.isNotEmpty)
                      pw.Text(
                        'Vendor Code: ${customer.vendorCode}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                    if (invoice.placeOfSupply != null &&
                        invoice.placeOfSupply!.isNotEmpty)
                      pw.Text(
                        'Place of Supply: ${invoice.placeOfSupply}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                  ],
                ),
              ),
            ),
            // Right: Ship To
            pw.Expanded(
              child: pw.Container(
                height: 140,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: const pw.Border(
                    top: pw.BorderSide(width: 0.5),
                    bottom: pw.BorderSide(width: 0.5),
                    right: pw.BorderSide(width: 0.5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Ship To:',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      shipToName,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      shipToAddress,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    if (customer.gstin != null && customer.gstin!.isNotEmpty)
                      pw.Text(
                        'GSTIN: ${customer.gstin}',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (customer.vendorCode != null &&
                        customer.vendorCode!.isNotEmpty)
                      pw.Text(
                        'Vendor Code: ${customer.vendorCode}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildMetaRow(
    Invoice invoice,
    bool isDeliveryChallan,
    List<InvoiceItem> items,
    pw.Font monoFont,
    pw.Font monoFontBold,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            _buildMetaCol(
              'Date',
              PdfDateFormatter.formatDate(invoice.invoiceDate),
              bold: true,
            ),
            pw.SizedBox(width: 16),
            if (invoice.dueDate != null) ...[
              _buildMetaCol(
                'Due Date',
                PdfDateFormatter.formatDate(invoice.dueDate!),
                bold: true,
              ),
              pw.SizedBox(width: 16),
            ],
            if ((invoice.poNumber != null && invoice.poNumber!.isNotEmpty) ||
                (invoice.gpNumber != null && invoice.gpNumber!.isNotEmpty)) ...[
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    if (invoice.poNumber != null &&
                        invoice.poNumber!.isNotEmpty) ...[
                      pw.Text(
                        'PO No: ',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        invoice.poNumber!,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (invoice.poDate != null) ...[
                        pw.SizedBox(width: 16),
                        pw.Text(
                          'PO Date: ',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          PdfDateFormatter.formatDate(invoice.poDate!),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                    if (invoice.gpNumber != null &&
                        invoice.gpNumber!.isNotEmpty) ...[
                      if (invoice.poNumber != null &&
                          invoice.poNumber!.isNotEmpty)
                        pw.SizedBox(width: 16),
                      pw.Text(
                        'GP No: ',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        invoice.gpNumber!,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildMetaCol(
    String label,
    String value, {
    bool bold = false,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(color: PdfColors.black, fontSize: 8),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDeliveryDetails(Invoice invoice, Customer customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Dispatch Date:',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
              ),
              pw.Text(
                PdfDateFormatter.formatDate(invoice.invoiceDate),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Delivery Address:',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
              ),
              pw.Text(
                customer.address,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBody(
    InvoiceType type,
    List<InvoiceItem> items,
    Invoice invoice,
    pw.Font monoFont,
  ) {
    final bool isPurchase = type == InvoiceType.purchaseVoucher;
    final bool isDeliveryChallan = type == InvoiceType.deliveryChallan;
    final bool showGst =
        type != InvoiceType.billOfSupply && type != InvoiceType.deliveryChallan;

    return _buildStandardTable(
      items,
      showGst: showGst,
      isPurchase: isPurchase,
      isDeliveryChallan: isDeliveryChallan,
      monoFont: monoFont,
    );
  }


  static pw.Widget _buildStandardTable(
    List<InvoiceItem> items, {
    required bool showGst,
    bool isPurchase = false,
    bool isDeliveryChallan = false,
    required pw.Font monoFont,
  }) {
    final headers = [
      'Description',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      'Total',
    ];

    final data = items.map((item) {
      return [
        _buildDescriptionWidget(item.description),
        if (!isDeliveryChallan) item.hsnCode ?? '',
        pw.Text(
          item.qty?.toString() ?? '1',
          style: pw.TextStyle(font: monoFont),
        ),
        pw.Text(
          item.unitPrice.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
        if (showGst)
          pw.Text('${item.gstRate ?? 0}%', style: pw.TextStyle(font: monoFont)),
        pw.Text(
          item.lineTotal.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
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
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.black,
        fontSize: 8.5,
      ),
      headerDecoration: null,
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellHeight: 20,
      cellAlignments: alignments,
      cellStyle: const pw.TextStyle(fontSize: 8),
    );
  }

  static pw.Widget _buildDescriptionWidget(String description) {
    if (!description.contains('\n')) {
      return pw.Text(
        description,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      );
    }
    final lines = description.split('\n');
    final firstLine = lines.first;
    final otherLines = lines.skip(1).join('\n');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          firstLine,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          otherLines,
          style: const pw.TextStyle(fontSize: 7),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalsRow(
    Invoice invoice,
    List<InvoiceItem> items,
    double totalPaid,
    pw.Font monoFont,
    pw.Font monoFontBold,
  ) {
    final bool isBillOfSupply = invoice.invoiceType == InvoiceType.billOfSupply;

    // Grouping by tax rates
    Map<double, double> rateTaxableValue = {};
    Map<double, double> rateCgst = {};
    Map<double, double> rateSgst = {};
    Map<double, double> rateTotal = {};

    double totalTaxVal = 0.0;

    if (!isBillOfSupply && invoice.subtotal > 0) {
      final discountFactor =
          (invoice.subtotal - invoice.discountAmount) / invoice.subtotal;
      for (var item in items) {
        final rate = item.gstRate ?? 0.0;
        final taxable = item.lineTotal * discountFactor;
        rateTaxableValue[rate] = (rateTaxableValue[rate] ?? 0.0) + taxable;

        if (rate > 0) {
          final gstAmount = taxable * (rate / 100.0);
          rateCgst[rate] = (rateCgst[rate] ?? 0.0) + gstAmount / 2.0;
          rateSgst[rate] = (rateSgst[rate] ?? 0.0) + gstAmount / 2.0;
          rateTotal[rate] = (rateTotal[rate] ?? 0.0) + taxable + gstAmount;
        } else {
          rateTotal[rate] = (rateTotal[rate] ?? 0.0) + taxable;
        }
      }
    }

    totalTaxVal = invoice.cgstAmount + invoice.sgstAmount + invoice.igstAmount;
    final exactGrandTotal =
        (invoice.subtotal - invoice.discountAmount) +
        totalTaxVal +
        (invoice.deliveryCharge ?? 0);
    final roundedOff = invoice.grandTotal - exactGrandTotal;
    final amountDue = invoice.grandTotal - totalPaid;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        // Left side: Words + Signature
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Total: INR ${invoice.amountInWords} Only',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                'AUTHORIZED SIGNATORY',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 60), // space for stamp/signature
            ],
          ),
        ),
        pw.SizedBox(width: 16),
        // Right side: Rates + Totals
        pw.Container(
          width: 300,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (!isBillOfSupply && rateTaxableValue.keys.isNotEmpty) ...[
                // Rate Breakdown Table
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.black,
                      width: 0.5,
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'Rate',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'Taxable',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'CGST',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'SGST',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'Amount',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      for (final rate in rateTaxableValue.keys)
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(
                                '@${rate.toStringAsFixed(1)}%',
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  font: monoFont,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(
                                rateTaxableValue[rate]!.toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  font: monoFont,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(
                                (rateCgst[rate] ?? 0).toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  font: monoFont,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(
                                (rateSgst[rate] ?? 0).toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  font: monoFont,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(
                                rateTotal[rate]!.toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  font: monoFont,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              'TOTAL',
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              (invoice.subtotal - invoice.discountAmount)
                                  .toStringAsFixed(2),
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                                font: monoFont,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              invoice.cgstAmount.toStringAsFixed(2),
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                                font: monoFont,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              invoice.sgstAmount.toStringAsFixed(2),
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                                font: monoFont,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                              ((invoice.subtotal - invoice.discountAmount) +
                                      invoice.cgstAmount +
                                      invoice.sgstAmount)
                                  .toStringAsFixed(2),
                              style: pw.TextStyle(
                                fontSize: 7.5,
                                fontWeight: pw.FontWeight.bold,
                                font: monoFont,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              pw.SizedBox(height: 2),
              _buildTotalsLine(
                'Total Before Tax:',
                (invoice.subtotal - invoice.discountAmount),
                monoFont,
                monoFontBold,
              ),

              if (invoice.deliveryCharge != null && invoice.deliveryCharge! > 0)
                _buildTotalsLine(
                  'Delivery Charge:',
                  invoice.deliveryCharge!,
                  monoFont,
                  monoFontBold,
                ),

              if (!isBillOfSupply && totalTaxVal > 0)
                _buildTotalsLine(
                  'Total Tax Amount:',
                  totalTaxVal,
                  monoFont,
                  monoFontBold,
                ),

              _buildTotalsLine(
                'Rounded Off:',
                roundedOff,
                monoFont,
                monoFontBold,
              ),
              pw.Divider(thickness: 1),
              _buildTotalsLine(
                'Total Amount:',
                invoice.grandTotal,
                monoFont,
                monoFontBold,
                isBold: true,
              ),
              pw.Divider(thickness: 1),
              _buildTotalsLine(
                'Amount Due:',
                amountDue,
                monoFont,
                monoFontBold,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalsLine(
    String label,
    double amount,
    pw.Font monoFont,
    pw.Font monoFontBold, {
    bool isBold = false,
  }) {
    final prefix = amount >= 0 && label == 'Rounded Off:' ? '+' : '';
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isBold ? 10 : 8.5,
            ),
          ),
          pw.Text(
            '$prefix${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              font: isBold ? monoFontBold : monoFont,
              fontSize: isBold ? 10 : 8.5,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(
    CompanySetting company,
    Invoice invoice,
    double totalPaid,
  ) {
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
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bank Details',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          'Bank Name: ${company.bankName}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        pw.Text(
                          'Account No: ${company.bankAccountNo}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        pw.Text(
                          'IFSC: ${company.bankIfsc}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        if (company.upiId != null && company.upiId!.isNotEmpty)
                          pw.Text(
                            'UPI ID: ${company.upiId}',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                      ],
                    ),
                    if (company.upiId != null &&
                        company.upiId!.isNotEmpty &&
                        (invoice.grandTotal - totalPaid) > 0) ...[
                      pw.SizedBox(width: 24),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 60,
                            height: 60,
                            child: pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data:
                                  'upi://pay?pa=${company.upiId}&pn=${Uri.encodeComponent(company.companyName)}&am=${(invoice.grandTotal - totalPaid).toStringAsFixed(2)}&cu=INR&tn=${Uri.encodeComponent(invoice.invoiceNo)}',
                              color: PdfColors.black,
                              drawText: false,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'Scan to pay via UPI',
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                pw.SizedBox(height: 10),
              ],
              if (isBillOfSupply)
                pw.Text(
                  'This is a Bill of Supply — no GST is charged on this transaction.',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),

              if (!isDeliveryChallan && !isPurchase)
                pw.Text(
                  'Thank you for your business.',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.black,
                  ),
                ),

              if (isDeliveryChallan) ...[
                pw.Container(
                  width: 100,
                  height: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      style: pw.BorderStyle.dashed,
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'e-Way Bill QR\n(Placeholder)',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        if (invoice.requiresEInvoice)
          pw.Container(
            width: 80,
            height: 80,
            margin: const pw.EdgeInsets.only(right: 16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
                style: pw.BorderStyle.dashed,
              ),
            ),
            child: pw.Center(
              child: pw.Text(
                'IRN QR\n(Placeholder)',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 7, color: PdfColors.black),
              ),
            ),
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
                pw.Text(
                  'Received in good condition',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '(Customer Sign)',
                  style: const pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
