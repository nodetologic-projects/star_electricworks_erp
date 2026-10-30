import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/reports/utils/excel_export.dart';

class TallyExportService {
  final InvoicesRepository repo;

  TallyExportService(this.repo);

  /// Exports Tally vouchers as Excel
  Future<String?> exportTallyExcel({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final invoicesWithCust = await repo.getInvoicesByDateRange(startDate, endDate);
    final nonDrafts = invoicesWithCust.where((i) => i.invoice.status != InvoiceStatus.draft).toList();

    if (nonDrafts.isEmpty) {
      return 'No transactions found for the selected period.';
    }

    final allInvoices = await repo.getAllInvoices();
    final invoiceMap = {for (final inv in allInvoices) inv.id: inv};

    final rows = <List<dynamic>>[
      [
        'Date',
        'Voucher Type',
        'Voucher No',
        'Party Name',
        'Party GSTIN',
        'Place of Supply',
        'Reference Doc No',
        'Taxable Value',
        'CGST',
        'SGST',
        'IGST',
        'Total Amount',
        'Narration',
      ],
    ];

    for (final item in nonDrafts) {
      final inv = item.invoice;
      final cust = item.customer;

      String voucherType;
      switch (inv.invoiceType) {
        case InvoiceType.credit_note:
          voucherType = 'Credit Note';
          break;
        case InvoiceType.debit_note:
          voucherType = 'Debit Note';
          break;
        case InvoiceType.serviceTaxInvoice:
        case InvoiceType.salesTaxInvoice:
        case InvoiceType.billOfSupply:
          voucherType = 'Sales';
          break;
        case InvoiceType.purchaseVoucher:
          voucherType = 'Purchase';
          break;
        case InvoiceType.deliveryChallan:
          voucherType = 'Delivery Note';
          break;
      }

      String refDoc = '';
      if (inv.originalInvoiceId != null) {
        refDoc = invoiceMap[inv.originalInvoiceId]?.invoiceNo ?? '';
      }

      final isCredit = inv.invoiceType == InvoiceType.credit_note;
      final mult = isCredit ? -1.0 : 1.0;

      rows.add([
        DateFormat('dd-MMM-yyyy').format(inv.invoiceDate),
        voucherType,
        inv.invoiceNo,
        cust.name,
        cust.gstin ?? '',
        inv.placeOfSupply ?? cust.state,
        refDoc,
        mult * inv.subtotal,
        mult * inv.cgstAmount,
        mult * inv.sgstAmount,
        mult * inv.igstAmount,
        mult * inv.grandTotal,
        inv.notes ?? (inv.noteReason != null ? inv.noteReason!.displayName : ''),
      ]);
    }

    final fileName = 'Tally_Vouchers_${DateFormat('yyyyMMdd').format(startDate)}_${DateFormat('yyyyMMdd').format(endDate)}';
    return await ExcelExport.exportData(fileName, rows);
  }

  /// Exports Tally vouchers as standard XML import
  Future<String?> exportTallyXml({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final invoicesWithCust = await repo.getInvoicesByDateRange(startDate, endDate);
    final nonDrafts = invoicesWithCust.where((i) => i.invoice.status != InvoiceStatus.draft).toList();

    if (nonDrafts.isEmpty) {
      return 'No transactions found for the selected period.';
    }

    final allInvoices = await repo.getAllInvoices();
    final invoiceMap = {for (final inv in allInvoices) inv.id: inv};

    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="utf-8"?>');
    buffer.writeln('<ENVELOPE>');
    buffer.writeln('  <HEADER>');
    buffer.writeln('    <TALLYREQUEST>Import Data</TALLYREQUEST>');
    buffer.writeln('  </HEADER>');
    buffer.writeln('  <BODY>');
    buffer.writeln('    <IMPORTDATA>');
    buffer.writeln('      <REQUESTDESC>');
    buffer.writeln('        <REPORTNAME>Vouchers</REPORTNAME>');
    buffer.writeln('      </REQUESTDESC>');
    buffer.writeln('      <REQUESTDATA>');

    for (final item in nonDrafts) {
      final inv = item.invoice;
      final cust = item.customer;

      String vchType;
      switch (inv.invoiceType) {
        case InvoiceType.credit_note:
          vchType = 'Credit Note';
          break;
        case InvoiceType.debit_note:
          vchType = 'Debit Note';
          break;
        case InvoiceType.serviceTaxInvoice:
        case InvoiceType.salesTaxInvoice:
        case InvoiceType.billOfSupply:
          vchType = 'Sales';
          break;
        case InvoiceType.purchaseVoucher:
          vchType = 'Purchase';
          break;
        case InvoiceType.deliveryChallan:
          vchType = 'Delivery Note';
          break;
      }

      final dateStr = DateFormat('yyyyMMdd').format(inv.invoiceDate);
      final refDoc = inv.originalInvoiceId != null ? (invoiceMap[inv.originalInvoiceId]?.invoiceNo ?? '') : '';

      buffer.writeln('        <TALLYMESSAGE xmlns:UDF="TallyUDF">');
      buffer.writeln('          <VOUCHER VCHTYPE="$vchType" ACTION="Create">');
      buffer.writeln('            <DATE>$dateStr</DATE>');
      buffer.writeln('            <VOUCHERTYPENAME>$vchType</VOUCHERTYPENAME>');
      buffer.writeln('            <VOUCHERNUMBER>${_escapeXml(inv.invoiceNo)}</VOUCHERNUMBER>');
      if (refDoc.isNotEmpty) {
        buffer.writeln('            <REFERENCE>${_escapeXml(refDoc)}</REFERENCE>');
      }
      buffer.writeln('            <PARTYLEDGERNAME>${_escapeXml(cust.name)}</PARTYLEDGERNAME>');
      buffer.writeln('            <NARRATION>${_escapeXml(inv.notes ?? (inv.noteReason?.displayName ?? ''))}</NARRATION>');
      buffer.writeln('            <ALLLEDGERENTRIES.LIST>');
      buffer.writeln('              <LEDGERNAME>${_escapeXml(cust.name)}</LEDGERNAME>');
      buffer.writeln('              <ISDEEMEDPOSITIVE>${inv.invoiceType == InvoiceType.credit_note ? 'No' : 'Yes'}</ISDEEMEDPOSITIVE>');
      buffer.writeln('              <AMOUNT>${inv.grandTotal.toStringAsFixed(2)}</AMOUNT>');
      buffer.writeln('            </ALLLEDGERENTRIES.LIST>');
      if (inv.subtotal > 0) {
        buffer.writeln('            <ALLLEDGERENTRIES.LIST>');
        buffer.writeln('              <LEDGERNAME>Sales Account</LEDGERNAME>');
        buffer.writeln('              <ISDEEMEDPOSITIVE>${inv.invoiceType == InvoiceType.credit_note ? 'Yes' : 'No'}</ISDEEMEDPOSITIVE>');
        buffer.writeln('              <AMOUNT>-${inv.subtotal.toStringAsFixed(2)}</AMOUNT>');
        buffer.writeln('            </ALLLEDGERENTRIES.LIST>');
      }
      if (inv.cgstAmount > 0) {
        buffer.writeln('            <ALLLEDGERENTRIES.LIST>');
        buffer.writeln('              <LEDGERNAME>Output CGST</LEDGERNAME>');
        buffer.writeln('              <ISDEEMEDPOSITIVE>${inv.invoiceType == InvoiceType.credit_note ? 'Yes' : 'No'}</ISDEEMEDPOSITIVE>');
        buffer.writeln('              <AMOUNT>-${inv.cgstAmount.toStringAsFixed(2)}</AMOUNT>');
        buffer.writeln('            </ALLLEDGERENTRIES.LIST>');
      }
      if (inv.sgstAmount > 0) {
        buffer.writeln('            <ALLLEDGERENTRIES.LIST>');
        buffer.writeln('              <LEDGERNAME>Output SGST</LEDGERNAME>');
        buffer.writeln('              <ISDEEMEDPOSITIVE>${inv.invoiceType == InvoiceType.credit_note ? 'Yes' : 'No'}</ISDEEMEDPOSITIVE>');
        buffer.writeln('              <AMOUNT>-${inv.sgstAmount.toStringAsFixed(2)}</AMOUNT>');
        buffer.writeln('            </ALLLEDGERENTRIES.LIST>');
      }
      if (inv.igstAmount > 0) {
        buffer.writeln('            <ALLLEDGERENTRIES.LIST>');
        buffer.writeln('              <LEDGERNAME>Output IGST</LEDGERNAME>');
        buffer.writeln('              <ISDEEMEDPOSITIVE>${inv.invoiceType == InvoiceType.credit_note ? 'Yes' : 'No'}</ISDEEMEDPOSITIVE>');
        buffer.writeln('              <AMOUNT>-${inv.igstAmount.toStringAsFixed(2)}</AMOUNT>');
        buffer.writeln('            </ALLLEDGERENTRIES.LIST>');
      }
      buffer.writeln('          </VOUCHER>');
      buffer.writeln('        </TALLYMESSAGE>');
    }

    buffer.writeln('      </REQUESTDATA>');
    buffer.writeln('    </IMPORTDATA>');
    buffer.writeln('  </BODY>');
    buffer.writeln('</ENVELOPE>');

    final xmlBytes = utf8.encode(buffer.toString());
    final savePath = await FilePicker.saveFile(
      dialogTitle: 'Save Tally XML Vouchers',
      fileName: 'Tally_Vouchers_${DateFormat('yyyyMMdd').format(startDate)}_${DateFormat('yyyyMMdd').format(endDate)}.xml',
      type: FileType.custom,
      allowedExtensions: ['xml'],
      bytes: Uint8List.fromList(xmlBytes),
    );

    if (savePath != null) {
      final f = File(savePath.toFilePath());
      await f.writeAsBytes(xmlBytes);
      return savePath.toFilePath();
    }

    return null;
  }

  static String _escapeXml(String s) {
    return s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
