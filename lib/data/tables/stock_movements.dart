import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/tables/copper_stock.dart';
import 'package:starelectricerp/data/tables/invoices.dart';

class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get copperStockId => integer().references(CopperStock, #id)();
  TextColumn get movementType => textEnum<MovementType>()();
  RealColumn get weightKg => real()();
  IntColumn get referenceInvoiceId => integer().nullable().references(Invoices, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
