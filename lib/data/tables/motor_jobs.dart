import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/tables/customers.dart';

class MotorJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get jobNo => text().unique()();
  IntColumn get customerId => integer().references(Customers, #id)();
  TextColumn get motorDescription => text()();
  TextColumn get motorMake => text().nullable()();
  RealColumn get hp => real().nullable()();
  TextColumn get phase => textEnum<Phase>().nullable()();
  DateTimeColumn get dateReceived => dateTime()();
  TextColumn get jobDescription => text()();
  TextColumn get status => textEnum<MotorJobStatus>()();
  RealColumn get serviceCharge => real().nullable()();
  TextColumn get sacCode => text().nullable()();
  DateTimeColumn get dispatchDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
