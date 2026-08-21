import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class CompanySettings extends Table {
  IntColumn get id => integer().autoIncrement()(); // Expected to always be 1
  TextColumn get companyName => text()();
  TextColumn get address => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get gstin => text()();
  TextColumn get bankName => text()();
  TextColumn get bankAccountNo => text()();
  TextColumn get bankIfsc => text()();
  TextColumn get dscCertPath => text().nullable()();
  TextColumn get dscSigningMethod => textEnum<DscSigningMethod>().nullable()();
  TextColumn get dscPkcs11DllPath => text().nullable()();
  BoolColumn get eInvoiceApplicable => boolean().withDefault(const Constant(false))();
  TextColumn get logoPath => text().nullable()();
}
