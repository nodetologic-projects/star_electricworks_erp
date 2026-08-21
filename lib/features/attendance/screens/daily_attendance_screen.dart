import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:rxdart/rxdart.dart';

class DailyAttendanceScreen extends ConsumerStatefulWidget {
  const DailyAttendanceScreen({super.key});

  @override
  ConsumerState<DailyAttendanceScreen> createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends ConsumerState<DailyAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _markAttendance(int employeeId, AttendanceStatus status, AttendanceRecord? existingRecord) async {
    final db = ref.read(databaseProvider);
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (existingRecord == null) {
      await db.into(db.attendanceRecords).insert(AttendanceRecordsCompanion.insert(
        employeeId: employeeId,
        date: normalizedDate,
        status: status,
      ));
    } else {
      await (db.update(db.attendanceRecords)..where((tbl) => tbl.id.equals(existingRecord.id))).write(
        AttendanceRecordsCompanion(status: drift.Value(status)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    return AppLayout(
      currentRoute: '/attendance',
      appBar: AppBar(
        title: const Text('Daily Attendance'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Change Date'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream: Rx.combineLatest2(
                db.select(db.employees).watch(),
                db.select(db.attendanceRecords).watch(),
                (List<Employee> employees, List<AttendanceRecord> records) {
                  return {
                    'employees': employees.where((e) => e.isActive).toList(),
                    'records': records.where((r) => r.date == normalizedDate).toList(),
                  };
                }
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data as Map<String, dynamic>;
                final employees = data['employees'] as List<Employee>;
                final records = data['records'] as List<AttendanceRecord>;

                if (employees.isEmpty) {
                  return const Center(child: Text('No active employees found.'));
                }

                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    final existingRecord = records.where((r) => r.employeeId == employee.id).firstOrNull;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<AttendanceStatus>(
                              segments: const [
                                ButtonSegment(value: AttendanceStatus.present, label: Text('Present')),
                                ButtonSegment(value: AttendanceStatus.absent, label: Text('Absent')),
                                ButtonSegment(value: AttendanceStatus.halfDay, label: Text('Half Day')),
                                ButtonSegment(value: AttendanceStatus.leave, label: Text('Leave')),
                              ],
                              emptySelectionAllowed: true,
                              selected: existingRecord == null ? <AttendanceStatus>{} : {existingRecord.status},
                              onSelectionChanged: (Set<AttendanceStatus> newSelection) {
                                if (newSelection.isNotEmpty) {
                                  _markAttendance(employee.id, newSelection.first, existingRecord);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
