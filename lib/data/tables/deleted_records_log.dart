import 'package:drift/drift.dart';

class DeletedRecordsLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // 'Invoice', 'MotorJob', 'Quotation'
  IntColumn get entityId => integer()();
  TextColumn get deletedAt => text()(); // ISO8601 string
  TextColumn get snapshot => text()(); // JSON string of key fields
}
