import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/tables/employees.dart';

class AttendanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => textEnum<AttendanceStatus>()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, date},
      ];
}
