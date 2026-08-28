import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/tables/products.dart';
import 'package:starelectricerp/data/tables/customers.dart';
import 'package:starelectricerp/data/tables/motor_jobs.dart';
import 'package:starelectricerp/data/tables/copper_stock.dart';
import 'package:starelectricerp/data/tables/invoices.dart';
import 'package:starelectricerp/data/tables/invoice_items.dart';
import 'package:starelectricerp/data/tables/stock_movements.dart';
import 'package:starelectricerp/data/tables/company_settings.dart';
import 'package:starelectricerp/data/tables/employees.dart';
import 'package:starelectricerp/data/tables/attendance_records.dart';
import 'package:starelectricerp/data/tables/financial_year_sequence.dart';
import 'package:starelectricerp/data/tables/cash_categories.dart';
import 'package:starelectricerp/data/tables/cash_transactions.dart';
import 'package:starelectricerp/data/tables/payments.dart';
import 'package:starelectricerp/data/tables/quotations.dart';
import 'package:starelectricerp/data/tables/deleted_records_log.dart';
import 'package:starelectricerp/data/tables/purchases.dart';
import 'package:starelectricerp/core/financial_year.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Products,
  Customers,
  MotorJobs,
  CopperStock,
  Invoices,
  InvoiceItems,
  StockMovements,
  CompanySettings,
  Employees,
  AttendanceRecords,
  FinancialYearSequence,
  CashCategories,
  CashTransactions,
  Payments,
  Quotations,
  DeletedRecordsLog,
  Purchases,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        print('DRIFT: onCreate started');
        await m.createAll();
        print('DRIFT: onCreate finished');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        print('DRIFT: onUpgrade started from $from to $to');
        if (from == 1) {
          // For dev, just recreate all missing tables. Since we don't know what existed, 
          // we just create all. Drift will ignore if they exist? No, createTable fails if it exists.
          // Let's just create the newly added ones:
          try { await m.createTable(copperStock); } catch (_) {}
          try { await m.createTable(stockMovements); } catch (_) {}
          try { await m.createTable(invoices); } catch (_) {}
          try { await m.createTable(invoiceItems); } catch (_) {}
          try { await m.createTable(motorJobs); } catch (_) {}
          try { await m.createTable(customers); } catch (_) {}
          try { await m.createTable(products); } catch (_) {}
          try { await m.createTable(companySettings); } catch (_) {}
        }
        if (from < 3) {
          try { await m.createTable(employees); } catch (_) {}
          try { await m.createTable(attendanceRecords); } catch (_) {}
        }
        if (from < 4) {
          try { await m.addColumn(invoices, invoices.notes); } catch (_) {}
        }
        if (from < 5) {
          try { await m.createTable(financialYearSequence); } catch (_) {}
          await _migrateToFinancialYearInvoiceNumbers(this);
        }
        if (from < 6) {
          try { await m.createTable(cashCategories); } catch (_) {}
          try { await m.createTable(cashTransactions); } catch (_) {}
        }
        if (from < 7) {
          try { await m.createTable(payments); } catch (_) {}
        }
        if (from < 8) {
          try { await m.addColumn(invoices, invoices.reminderSentDate); } catch (_) {}
        }
        if (from < 9) {
          try { await m.createTable(quotations); } catch (_) {}
        }
        if (from < 10) {
          try { await m.addColumn(invoices, invoices.igstAmount); } catch (_) {}
          try { await m.addColumn(invoices, invoices.shipToName); } catch (_) {}
          try { await m.addColumn(invoices, invoices.shipToAddress); } catch (_) {}
          try { await m.addColumn(invoices, invoices.placeOfSupply); } catch (_) {}
          try { await m.addColumn(invoices, invoices.poNumber); } catch (_) {}
          try { await m.addColumn(invoices, invoices.poDate); } catch (_) {}
          try { await m.addColumn(invoices, invoices.gpNumber); } catch (_) {}
          try { await m.addColumn(customers, customers.vendorCode); } catch (_) {}
        }
        if (from < 11) {
          try { await m.addColumn(invoices, invoices.paymentTermDays); } catch (_) {}
        }
        if (from < 12) {
          try { await m.addColumn(motorJobs, motorJobs.sacCode); } catch (_) {}
          try { await m.addColumn(motorJobs, motorJobs.gpNumber); } catch (_) {}
          try { await m.addColumn(motorJobs, motorJobs.gpDate); } catch (_) {}
        }
        if (from < 14) {
          try { await m.createTable(deletedRecordsLog); } catch (_) {}
          try { await m.addColumn(customers, customers.isActive); } catch (_) {}
        }
        if (from < 15) {
          try { await m.addColumn(invoiceItems, invoiceItems.hsnCode); } catch (_) {}
          try { await m.addColumn(copperStock, copperStock.hsnCode); } catch (_) {}
        }
        if (from < 16) {
          try { await m.addColumn(companySettings, companySettings.upiId); } catch (_) {}
        }
        if (from < 17) {
          try { await m.createTable(purchases); } catch (_) {}
        }
      },
      beforeOpen: (details) async {
        print('DRIFT: beforeOpen started');
        await customStatement('PRAGMA foreign_keys = ON');
        print('DRIFT: beforeOpen finished');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    print('DRIFT: LazyDatabase init started');
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'starelectricerp.sqlite'));

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    print('DRIFT: Returning NativeDatabase');
    print('DRIFT: Using SYNC NativeDatabase');
    return NativeDatabase(file, logStatements: true);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

Future<void> _migrateToFinancialYearInvoiceNumbers(AppDatabase db) async {
  // 1. Get all invoices ordered by date
  final allInvoices = await (db.select(db.invoices)..orderBy([(t) => OrderingTerm(expression: t.invoiceDate)])).get();

  // Track max number per prefix + label
  final Map<String, int> maxNumbers = {};

  for (final inv in allInvoices) {
    final prefix = _getPrefixForType(inv.invoiceType);
    final label = FinancialYear.getLabelForDate(inv.invoiceDate);
    final key = '$prefix-$label';

    int currentNumber = (maxNumbers[key] ?? 0) + 1;
    maxNumbers[key] = currentNumber;

    final newInvoiceNo = '$prefix-${FinancialYear.getRolloverLabel(label, currentNumber)}';

    await (db.update(db.invoices)..where((t) => t.id.equals(inv.id))).write(
      InvoicesCompanion(invoiceNo: Value(newInvoiceNo)),
    );
  }

  // Seed the FinancialYearSequence table
  for (final entry in maxNumbers.entries) {
    final parts = entry.key.split('-');
    await db.into(db.financialYearSequence).insert(
      FinancialYearSequenceCompanion.insert(
        invoiceTypePrefix: parts[0],
        financialYearLabel: parts[1],
        lastNumber: Value(entry.value),
      ),
    );
  }
}

String _getPrefixForType(InvoiceType type) {
  switch (type) {
    case InvoiceType.serviceTaxInvoice: return 'INV';
    case InvoiceType.salesTaxInvoice: return 'INV';
    case InvoiceType.billOfSupply: return 'BOS';
    case InvoiceType.purchaseVoucher: return 'PUR';
    case InvoiceType.deliveryChallan: return 'DC';
  }
}

