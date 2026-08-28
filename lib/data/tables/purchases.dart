import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vendorName => text()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  RealColumn get gstAmount => real().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  TextColumn get paymentMode => textEnum<PaymentMode>().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
