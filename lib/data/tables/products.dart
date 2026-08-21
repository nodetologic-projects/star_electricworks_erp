import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get sku => text()();
  TextColumn get hsnCode => text()();
  RealColumn get gstRate => real()();
  RealColumn get unitPrice => real()();
  IntColumn get stockQty => integer()();
  IntColumn get reorderLevel => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
