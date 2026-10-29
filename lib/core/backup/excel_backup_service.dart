import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/utils/permission_util.dart';

final excelBackupServiceProvider = Provider((ref) {
  return ExcelBackupService(ref.watch(databaseProvider));
});

class ExcelBackupService {
  final AppDatabase _db;
  final _dateFmt = DateFormat('dd/MM/yyyy');
  final _dtFmt = DateFormat('dd/MM/yyyy HH:mm');

  ExcelBackupService(this._db);

  String _fmtDate(DateTime? dt) => dt == null ? '' : _dateFmt.format(dt);
  String _fmtDT(DateTime? dt) => dt == null ? '' : _dtFmt.format(dt);

  void _writeSheet(
    Excel excel,
    String sheetName,
    List<String> headers,
    List<List<dynamic>> rows,
  ) {
    final sheet = excel[sheetName];

    for (int j = 0; j < headers.length; j++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: j, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[j]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#1F3864'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      );
    }

    for (int i = 0; i < rows.length; i++) {
      for (int j = 0; j < rows[i].length; j++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1),
        );
        final value = rows[i][j];
        if (value == null || value == '') {
          cell.value = null;
        } else if (value is num) {
          cell.value = DoubleCellValue(value.toDouble());
        } else {
          cell.value = TextCellValue(value.toString());
        }
      }
    }

    for (int j = 0; j < headers.length; j++) {
      sheet.setColumnWidth(j, 22);
    }
  }

  Future<void> _addCustomers(Excel excel) async {
    final data = await (_db.select(
      _db.customers,
    )..orderBy([(c) => drift.OrderingTerm(expression: c.name)])).get();
    _writeSheet(
      excel,
      'Customers',
      [
        'Name',
        'Phone',
        'Email',
        'GSTIN',
        'State',
        'Address',
        'Vendor Code',
        'Active',
        'Created At',
      ],
      data
          .map(
            (c) => [
              c.name,
              c.phone,
              c.email,
              c.gstin ?? '',
              c.state,
              c.address,
              c.vendorCode ?? '',
              c.isActive ? 'Yes' : 'No',
              _fmtDT(c.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addInvoices(Excel excel) async {
    final data =
        await (_db.select(_db.invoices)..orderBy([
              (i) => drift.OrderingTerm(
                expression: i.invoiceDate,
                mode: drift.OrderingMode.desc,
              ),
              (i) => drift.OrderingTerm(
                expression: i.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Invoices',
      [
        'Invoice No',
        'Type',
        'Customer ID',
        'Date',
        'Due Date',
        'Subtotal',
        'CGST',
        'SGST',
        'IGST',
        'Tax Mode',
        'Discount',
        'Delivery',
        'Grand Total',
        'Status',
        'PO No',
        'GP No',
        'Place of Supply',
        'Notes',
        'Created At',
      ],
      data
          .map(
            (i) => [
              i.invoiceNo,
              i.invoiceType.name,
              i.customerId,
              _fmtDate(i.invoiceDate),
              _fmtDate(i.dueDate),
              i.subtotal,
              i.cgstAmount,
              i.sgstAmount,
              i.igstAmount,
              i.taxMode == TaxMode.all_three ? TaxMode.cgst_sgst.name : i.taxMode.name,
              i.discountAmount,
              i.deliveryCharge ?? 0,
              i.grandTotal,
              i.status.name,
              i.poNumber ?? '',
              i.gpNumber ?? '',
              i.placeOfSupply ?? '',
              i.notes ?? '',
              _fmtDT(i.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addInvoiceItems(Excel excel) async {
    final data = await _db.select(_db.invoiceItems).get();
    _writeSheet(
      excel,
      'Invoice Items',
      [
        'ID',
        'Invoice ID',
        'Source',
        'Motor Job ID',
        'Copper Stock ID',
        'Description',
        'HSN',
        'Qty',
        'Unit Price',
        'GST%',
        'Line Total',
      ],
      data
          .map(
            (item) => [
              item.id,
              item.invoiceId,
              item.itemSourceType.name,
              item.motorJobId ?? '',
              item.copperStockId ?? '',
              item.description,
              item.hsnCode ?? '',
              item.qty ?? '',
              item.unitPrice,
              item.gstRate ?? '',
              item.lineTotal,
            ],
          )
          .toList(),
    );
  }

  Future<void> _addMotorJobs(Excel excel) async {
    final data =
        await (_db.select(_db.motorJobs)..orderBy([
              (j) => drift.OrderingTerm(
                expression: j.dateReceived,
                mode: drift.OrderingMode.desc,
              ),
              (j) => drift.OrderingTerm(
                expression: j.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Motor Jobs',
      [
        'Job No',
        'Customer ID',
        'Description',
        'Make',
        'HP',
        'Phase',
        'Date Received',
        'Job Work',
        'Status',
        'Service Charge',
        'SAC/HSN Code',
        'GP No',
        'GP Date',
        'Dispatch Date',
        'Created At',
      ],
      data
          .map(
            (j) => [
              j.jobNo,
              j.customerId,
              j.motorDescription,
              j.motorMake ?? '',
              j.hp ?? '',
              j.phase?.name ?? '',
              _fmtDate(j.dateReceived),
              j.jobDescription,
              j.status.name,
              j.serviceCharge ?? '',
              j.sacCode ?? '',
              j.gpNumber ?? '',
              _fmtDate(j.gpDate),
              _fmtDate(j.dispatchDate),
              _fmtDT(j.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addCopperStock(Excel excel) async {
    final data = await _db.select(_db.copperStock).get();
    _writeSheet(
      excel,
      'Copper Stock',
      [
        'Type',
        'Description',
        'HSN',
        'Stock Qty (kg)',
        'Reorder Level (kg)',
        'Price/kg',
        'GST%',
        'Active',
        'Created At',
      ],
      data
          .map(
            (s) => [
              s.copperType.name,
              s.description,
              s.hsnCode ?? '',
              s.stockQtyKg,
              s.reorderLevelKg ?? '',
              s.pricePerKg,
              s.gstRate ?? '',
              s.isActive ? 'Yes' : 'No',
              _fmtDT(s.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addEmployees(Excel excel) async {
    final data = await _db.select(_db.employees).get();
    _writeSheet(
      excel,
      'Employees',
      [
        'Name',
        'Role',
        'Phone',
        'Daily Wage',
        'Joining Date',
        'Active',
        'Created At',
      ],
      data
          .map(
            (e) => [
              e.name,
              e.role ?? '',
              e.phone ?? '',
              e.dailyWage ?? '',
              _fmtDate(e.joiningDate),
              e.isActive ? 'Yes' : 'No',
              _fmtDT(e.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addAttendance(Excel excel) async {
    final data =
        await (_db.select(_db.attendanceRecords)..orderBy([
              (a) => drift.OrderingTerm(
                expression: a.date,
                mode: drift.OrderingMode.desc,
              ),
              (a) => drift.OrderingTerm(
                expression: a.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Attendance',
      ['Employee ID', 'Date', 'Status', 'Notes'],
      data
          .map(
            (a) => [
              a.employeeId,
              _fmtDate(a.date),
              a.status.name,
              a.notes ?? '',
            ],
          )
          .toList(),
    );
  }

  Future<void> _addQuotations(Excel excel) async {
    final data =
        await (_db.select(_db.quotations)..orderBy([
              (q) => drift.OrderingTerm(
                expression: q.createdAt,
                mode: drift.OrderingMode.desc,
              ),
              (q) => drift.OrderingTerm(
                expression: q.id,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Quotations',
      [
        'Quote No',
        'Customer ID',
        'Prospective Name',
        'Prospective Phone',
        'Description',
        'Est. Amount',
        'Valid Until',
        'Status',
        'Created At',
      ],
      data
          .map(
            (q) => [
              q.quoteNo,
              q.customerId ?? '',
              q.prospectiveCustomerName ?? '',
              q.prospectiveCustomerPhone ?? '',
              q.description,
              q.estimatedAmount,
              _fmtDate(q.validUntil),
              q.status.name,
              _fmtDT(q.createdAt),
            ],
          )
          .toList(),
    );
  }

  Future<void> _addCashBook(Excel excel) async {
    final data =
        await (_db.select(_db.cashTransactions)..orderBy([
              (t) => drift.OrderingTerm(
                expression: t.transactionDate,
                mode: drift.OrderingMode.desc,
              ),
              (t) => drift.OrderingTerm(
                expression: t.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Cash Book',
      ['Date', 'Type', 'Category', 'Description', 'Amount'],
      data
          .map(
            (t) => [
              _fmtDate(t.transactionDate),
              t.transactionType.name,
              t.category,
              t.description ?? '',
              t.amount,
            ],
          )
          .toList(),
    );
  }

  Future<void> _addPayments(Excel excel) async {
    final data =
        await (_db.select(_db.payments)..orderBy([
              (p) => drift.OrderingTerm(
                expression: p.paymentDate,
                mode: drift.OrderingMode.desc,
              ),
              (p) => drift.OrderingTerm(
                expression: p.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    _writeSheet(
      excel,
      'Payments',
      ['Invoice ID', 'Amount', 'Date', 'Method', 'Reference', 'Notes'],
      data
          .map(
            (p) => [
              p.invoiceId,
              p.amount,
              _fmtDate(p.paymentDate),
              p.paymentMode.name,
              p.referenceNo ?? '',
              p.notes ?? '',
            ],
          )
          .toList(),
    );
  }

  // ── Main Entry Point ─────────────────────────────────────────────────────

  Future<String?> exportFullBackup() async {
    final hasPermission = await PermissionUtil.requestStoragePermission();
    if (!hasPermission) throw Exception('Storage permission denied');

    final excel = Excel.createExcel();
    // Remove default empty sheet
    if (excel.sheets.containsKey('Sheet1')) excel.delete('Sheet1');

    await _addCustomers(excel);
    await _addInvoices(excel);
    await _addInvoiceItems(excel);
    await _addMotorJobs(excel);
    await _addCopperStock(excel);
    await _addEmployees(excel);
    await _addAttendance(excel);
    await _addQuotations(excel);
    await _addCashBook(excel);
    await _addPayments(excel);

    final bytes = excel.save();
    if (bytes == null) throw Exception('Failed to generate Excel file');

    final fileName =
        'StarElectric_Backup_${DateFormat("yyyy-MM-dd_HHmm").format(DateTime.now())}';

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Save Excel Backup',
      fileName: '$fileName.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: Uint8List.fromList(bytes),
    );

    return savedPath?.toFilePath();
  }
}
