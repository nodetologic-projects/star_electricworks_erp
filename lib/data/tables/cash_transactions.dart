import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class CashTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionType => textEnum<CashTransactionType>()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
