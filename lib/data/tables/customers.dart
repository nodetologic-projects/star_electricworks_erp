import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get state => text()();
  TextColumn get gstin => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get vendorCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
