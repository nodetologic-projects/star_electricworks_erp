import 'package:drift/drift.dart';

class FinancialYearSequence extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceTypePrefix => text()(); // e.g. INV, BOS, PUR, DC
  TextColumn get financialYearLabel => text()(); // e.g. A, B
  IntColumn get lastNumber => integer().withDefault(const Constant(0))();
}
