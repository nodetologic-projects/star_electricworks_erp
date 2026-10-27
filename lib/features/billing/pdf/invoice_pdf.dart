import 'package:starelectricerp/core/date_formatting.dart';
import 'package:starelectricerp/core/pdf_fonts.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

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
    final theme = await PdfFontHelper.loadTheme();
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
              ),

              if (isDeliveryChallan) ...[
                pw.SizedBox(height: 10),
                _buildDeliveryDetails(invoice, customer),
              ],

              pw.SizedBox(height: 10),
              _buildBody(invoice.invoiceType, items, invoice),
              pw.SizedBox(height: 10),

              if (!isDeliveryChallan) ...[
                _buildTotalsRow(
                  invoice,
                  items,
                  totalPaid,
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
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              copyLabel,
              style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic, fontWeight: pw.FontWeight.bold),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '$typeLabel ${invoice.invoiceNo}',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#501817'),
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Date: ',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.TextSpan(
                        text: PdfDateFormatter.formatDate(invoice.invoiceDate),
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (invoice.dueDate != null) ...[
                  pw.SizedBox(height: 2),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: 'Due Date: ',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        pw.TextSpan(
                          text: PdfDateFormatter.formatDate(invoice.dueDate!),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // if (invoice.poNumber != null && invoice.poNumber!.isNotEmpty) ...[
                //   pw.SizedBox(height: 2),
                //   pw.RichText(text: pw.TextSpan(children: [
                //     pw.TextSpan(text: 'PO No: ', style: const pw.TextStyle(fontSize: 8)),
                //     pw.TextSpan(text: invoice.poNumber!, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                //   ])),
                // ],
                // if (invoice.poDate != null) ...[
                //   pw.SizedBox(height: 2),
                //   pw.RichText(text: pw.TextSpan(children: [
                //     pw.TextSpan(text: 'PO Date: ', style: const pw.TextStyle(fontSize: 8)),
                //     pw.TextSpan(text: PdfDateFormatter.formatDate(invoice.poDate!), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                //   ])),
                // ],
                // if (invoice.gpNumber != null && invoice.gpNumber!.isNotEmpty) ...[
                //   pw.SizedBox(height: 2),
                //   pw.RichText(text: pw.TextSpan(children: [
                //     pw.TextSpan(text: 'GP No: ', style: const pw.TextStyle(fontSize: 8)),
                //     pw.TextSpan(text: invoice.gpNumber!, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                //   ])),
                // ],
                // if (invoice.gpDate != null) ...[
                //   pw.SizedBox(height: 2),
                //   pw.RichText(text: pw.TextSpan(children: [
                //     pw.TextSpan(text: 'GP Date: ', style: const pw.TextStyle(fontSize: 8)),
                //     pw.TextSpan(text: PdfDateFormatter.formatDate(invoice.gpDate!), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                //   ])),
                // ],
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left: Company Info
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
                      company.companyName,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      company.address,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Ph: ${company.phone}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'Email: ${company.email}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Bank: ${company.bankName}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'A/C: ${company.bankAccountNo}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'IFSC: ${company.bankIfsc}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'GSTIN: ${company.gstin}',
                      style: pw.TextStyle(
                        fontSize: 7.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (company.gstin.length == 15)
                      pw.Text(
                        'PAN: ${company.gstin.substring(2, 12)}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                    if (invoice.paymentTermDays != null) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Payment Term: ${invoice.paymentTermDays} Days',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Middle: Bill To
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
                    if (customer.panNumber != null &&
                        customer.panNumber!.isNotEmpty)
                      pw.Text(
                        'PAN: ${customer.panNumber}',
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
                    if (customer.panNumber != null &&
                        customer.panNumber!.isNotEmpty)
                      pw.Text(
                        'PAN: ${customer.panNumber}',
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
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            // _buildMetaCol(
            //   'Date',
            //   PdfDateFormatter.formatDate(invoice.invoiceDate),
            //   bold: true,
            // ),
            // pw.SizedBox(width: 16),
            // if (invoice.dueDate != null) ...[
            //   _buildMetaCol(
            //     'Due Date',
            //     PdfDateFormatter.formatDate(invoice.dueDate!),
            //     bold: true,
            //   ),
            //   pw.SizedBox(width: 16),
            // ],
            if ((invoice.poNumber != null && invoice.poNumber!.isNotEmpty) ||
                (invoice.poDate != null) ||
                (invoice.gpNumber != null && invoice.gpNumber!.isNotEmpty) ||
                (invoice.gpDate != null)) ...[
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
                      if ((invoice.poNumber != null &&
                              invoice.poNumber!.isNotEmpty) ||
                          invoice.poDate != null)
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
                    if (invoice.gpDate != null) ...[
                      if ((invoice.poNumber != null &&
                              invoice.poNumber!.isNotEmpty) ||
                          invoice.poDate != null ||
                          (invoice.gpNumber != null &&
                              invoice.gpNumber!.isNotEmpty))
                        pw.SizedBox(width: 16),
                      pw.Text(
                        'GP Date: ',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        PdfDateFormatter.formatDate(invoice.gpDate!),
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
  ) {
    final bool isPurchase = type == InvoiceType.purchaseVoucher;
    final bool isDeliveryChallan = type == InvoiceType.deliveryChallan;
    final bool showGst =
        type != InvoiceType.billOfSupply && type != InvoiceType.deliveryChallan;

    return _buildStandardTable(
      items,
      invoice: invoice,
      showGst: showGst,
      isPurchase: isPurchase,
      isDeliveryChallan: isDeliveryChallan,
    );
  }

  static pw.Widget _buildStandardTable(
    List<InvoiceItem> items, {
    required Invoice invoice,
    required bool showGst,
    bool isPurchase = false,
    bool isDeliveryChallan = false,
  }) {
    final headers = [
      'Description',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      'Discount',
      if (showGst && !invoice.useIgst) 'CGST',
      if (showGst && !invoice.useIgst) 'SGST',
      if (showGst && invoice.useIgst) 'IGST',
      'Total',
    ];

    double sumItemDiscounts = 0.0;
    double postItemDiscountBaseline = 0.0;
    for (final item in items) {
      final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
      sumItemDiscounts += itemDiscount;
      postItemDiscountBaseline += (item.lineTotal - itemDiscount);
    }
    
    double bundleDiscountAmount = 0.0;
    // Only apply bundle discount for legacy invoices that have no per-item discounts
    if (sumItemDiscounts == 0 && invoice.discountAmount > 0) {
      bundleDiscountAmount = invoice.isDiscountPercentage
          ? (postItemDiscountBaseline * (invoice.discountRate ?? 0.0) / 100.0)
          : invoice.discountAmount;

      if (bundleDiscountAmount > postItemDiscountBaseline) {
        bundleDiscountAmount = postItemDiscountBaseline;
      }
    }

    final distributionFactor = invoice.distributeDiscountAcrossItems && postItemDiscountBaseline > 0
        ? (postItemDiscountBaseline - bundleDiscountAmount) / postItemDiscountBaseline
        : 1.0;

    final data = items.map((item) {
      final rate = item.gstRate ?? 0.0;
      final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
      final itemPostDiscount = item.lineTotal - itemDiscount;
      final bundleDiscountShare = invoice.distributeDiscountAcrossItems 
          ? itemPostDiscount * (1.0 - distributionFactor)
          : 0.0;
      final totalDiscount = itemDiscount + bundleDiscountShare;
      final effectivePct = item.lineTotal > 0 ? (totalDiscount / item.lineTotal) * 100 : 0.0;
      
      final lineTaxableValue = itemPostDiscount * distributionFactor;
      
      final gstAmount = showGst ? (lineTaxableValue * (rate / 100)) : 0.0;
      final cgstAmount = gstAmount / 2;
      final sgstAmount = gstAmount / 2;
      final igstAmount = gstAmount;
      final total = showGst ? (lineTaxableValue + gstAmount) : lineTaxableValue;

      final halfRateStr = (rate / 2).toStringAsFixed(1).replaceAll('.0', '');
      final fullRateStr = rate.toStringAsFixed(1).replaceAll('.0', '');

      return [
        _buildDescriptionWidget(item.description),
        if (!isDeliveryChallan) item.hsnCode ?? '',
        pw.Text(
          item.qty?.toString() ?? '1',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          item.unitPrice.toStringAsFixed(2),
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          totalDiscount > 0
              ? '-${totalDiscount.toStringAsFixed(2)}\n(${effectivePct.toStringAsFixed(1)}%)'
              : '0.00',
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.right,
        ),
        if (showGst && !invoice.useIgst)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                cgstAmount.toStringAsFixed(2),
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text('($halfRateStr%)', style: const pw.TextStyle(fontSize: 7)),
            ],
          ),
        if (showGst && !invoice.useIgst)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                sgstAmount.toStringAsFixed(2),
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text('($halfRateStr%)', style: const pw.TextStyle(fontSize: 7)),
            ],
          ),
        if (showGst && invoice.useIgst)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                igstAmount.toStringAsFixed(2),
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text('($fullRateStr%)', style: const pw.TextStyle(fontSize: 7)),
            ],
          ),
        pw.Text(total.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 8)),
      ];
    }).toList();

    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
      6: pw.Alignment.centerRight,
      7: pw.Alignment.centerRight,
    };

    if (isDeliveryChallan) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      };
    } else if (!showGst) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      };
    } else if (invoice.useIgst) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
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
    List<pw.TextSpan> spans = [];
    final pattern = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final match in pattern.allMatches(description)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          pw.TextSpan(
            text: description.substring(lastMatchEnd, match.start),
            style: const pw.TextStyle(fontSize: 8),
          ),
        );
      }
      spans.add(
        pw.TextSpan(
          text: match.group(1),
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < description.length) {
      spans.add(
        pw.TextSpan(
          text: description.substring(lastMatchEnd),
          style: const pw.TextStyle(fontSize: 8),
        ),
      );
    }

    return pw.RichText(text: pw.TextSpan(children: spans));
  }

  static pw.Widget _buildTotalsRow(
    Invoice invoice,
    List<InvoiceItem> items,
    double totalPaid,
  ) {
    final bool isBillOfSupply = invoice.invoiceType == InvoiceType.billOfSupply;

    double sumItemDiscounts = 0.0;
    for (final item in items) {
      final itemDiscount =
          item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
      sumItemDiscounts += itemDiscount;
    }
    final discountToShow =
        sumItemDiscounts > 0 ? sumItemDiscounts : invoice.discountAmount;

    final totalTaxVal =
        invoice.cgstAmount + invoice.sgstAmount + invoice.igstAmount;
    final exactGrandTotal =
        (invoice.subtotal - discountToShow) +
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
                'SIG_LOC',
                style: const pw.TextStyle(
                  fontSize: 1,
                  color: PdfColors.white,
                ),
              ),
              pw.Text(
                'AUTHORIZED SIGNATORY',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '(e-Signed)',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 40), // space for stamp/signature
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
              _buildTotalsLine(
                'Subtotal:',
                invoice.subtotal,
              ),
              if (discountToShow > 0)
                _buildTotalsLine(
                  'Discount:',
                  -discountToShow,
                ),
              if (discountToShow > 0)
                _buildTotalsLine(
                  'Total Before Tax:',
                  (invoice.subtotal - discountToShow),
                ),

              if (invoice.deliveryCharge != null && invoice.deliveryCharge! > 0)
                _buildTotalsLine(
                  'Delivery Charge:',
                  invoice.deliveryCharge!,
                ),

              if (!isBillOfSupply && totalTaxVal > 0)
                _buildTotalsLine(
                  'Total Tax Amount:',
                  totalTaxVal,
                ),

              _buildTotalsLine(
                'Rounded Off:',
                roundedOff,
              ),
              pw.Divider(thickness: 1),
              _buildTotalsLine(
                'Total Amount:',
                invoice.grandTotal,
                isBold: true,
              ),
              pw.Divider(thickness: 1),
              _buildTotalsLine(
                'Amount Due:',
                amountDue,
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
    double amount, {
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
    final bool shouldShowQr =
        company.upiId != null &&
        company.upiId!.isNotEmpty &&
        (invoice.grandTotal - totalPaid) > 0;

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
                    if (shouldShowQr) ...[
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
                            'Scan to pay via UPI\n₹${(invoice.grandTotal - totalPaid).toStringAsFixed(2)}',
                            textAlign: pw.TextAlign.center,
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
