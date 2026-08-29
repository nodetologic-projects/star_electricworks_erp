import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vendorName => text()();
  DateTimeColumn get purchaseDate => dateTime()();
  TextColumn get paymentMode => textEnum<PaymentMode>().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get billImagePath => text().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id)();
  TextColumn get category => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  RealColumn get gstAmount => real().nullable()();
}
