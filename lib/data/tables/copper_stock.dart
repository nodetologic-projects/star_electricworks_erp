import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class CopperStock extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get copperType => textEnum<CopperType>()();
  TextColumn get description => text()();
  RealColumn get weightKg => real()();
  RealColumn get pricePerKg => real()();
  RealColumn get gstRate => real().nullable()();
  TextColumn get hsnCode => text().nullable()();
  RealColumn get stockQtyKg => real()();
  RealColumn get reorderLevelKg => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
