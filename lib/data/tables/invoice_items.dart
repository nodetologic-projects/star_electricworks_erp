import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/tables/invoices.dart';
import 'package:starelectricerp/data/tables/motor_jobs.dart';
import 'package:starelectricerp/data/tables/copper_stock.dart';

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  TextColumn get itemSourceType => textEnum<ItemSourceType>()();
  IntColumn get motorJobId => integer().nullable().references(MotorJobs, #id)();
  IntColumn get copperStockId => integer().nullable().references(CopperStock, #id)();
  TextColumn get description => text()();
  TextColumn get rateRs => text().nullable()();
  TextColumn get hsnCode => text().nullable()();
  RealColumn get qty => real().nullable()();
  RealColumn get unitPrice => real()();
  RealColumn get gstRate => real().nullable()();
  RealColumn get lineTotal => real()();
}
