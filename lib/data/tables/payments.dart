import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

import 'package:starelectricerp/data/tables/invoices.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  RealColumn get amount => real()();
  TextColumn get paymentMode => textEnum<PaymentMode>()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get referenceNo => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
