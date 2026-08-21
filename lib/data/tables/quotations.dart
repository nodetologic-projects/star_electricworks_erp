import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/customers.dart';
import 'package:starelectricerp/data/tables/motor_jobs.dart';
import 'package:starelectricerp/data/tables/invoices.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class Quotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteNo => text().unique()();
  
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  TextColumn get prospectiveCustomerName => text().nullable()();
  TextColumn get prospectiveCustomerPhone => text().nullable()();
  
  IntColumn get motorJobId => integer().nullable().references(MotorJobs, #id)();
  
  TextColumn get description => text()();
  RealColumn get estimatedAmount => real()();
  
  DateTimeColumn get validUntil => dateTime().nullable()();
  TextColumn get status => textEnum<QuotationStatus>()();
  
  IntColumn get convertedInvoiceId => integer().nullable().references(Invoices, #id)();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
