import 'package:intl/intl.dart' as import_intl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:drift/drift.dart' as drift;
import 'package:rxdart/rxdart.dart';

class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends ConsumerState<AttendanceHistoryScreen> {
  int? _selectedEmployeeId;
  DateTime _selectedMonth = DateTime.now();

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month, 1);
      });
    }
  }


  Future<void> _confirmDeleteRecord(BuildContext context, AttendanceRecord record) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Record?'),
        content: Text('Are you sure you want to delete the attendance record for ${import_intl.DateFormat('dd MMM yyyy').format(record.date)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (res == true && context.mounted) {
      final db = ProviderScope.containerOf(context, listen: false).read(databaseProvider);
      await (db.delete(db.attendanceRecords)..where((tbl) => tbl.id.equals(record.id))).go();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record deleted.')));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return AppLayout(
      currentRoute: '/attendance',
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<List<Employee>>(
                    stream: db.select(db.employees).watch(),
                    builder: (context, snapshot) {
                      final employees = snapshot.data ?? [];
                      return DropdownButton<int>(
                        hint: const Text('Select Employee'),
                        value: _selectedEmployeeId,
                        items: employees
                            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedEmployeeId = val),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickMonth,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(DateFormat('MMMM yyyy').format(_selectedMonth)),
                ),
              ],
            ),
          ),
          const Divider(),
          if (_selectedEmployeeId == null)
            const Expanded(child: Center(child: Text('Please select an employee.')))
          else
            Expanded(
              child: StreamBuilder(
                stream: Rx.combineLatest2(
                  (db.select(db.employees)..where((tbl) => tbl.id.equals(_selectedEmployeeId!))).watchSingle(),
                  (db.select(db.attendanceRecords)
                        ..where((tbl) => tbl.employeeId.equals(_selectedEmployeeId!))
                        ..where((tbl) => tbl.date.isBiggerOrEqualValue(DateTime(_selectedMonth.year, _selectedMonth.month, 1)))
                        ..where((tbl) => tbl.date.isSmallerThanValue(DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1))))
                      .watch(),
                  (Employee employee, List<AttendanceRecord> records) => {'employee': employee, 'records': records}
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data as Map<String, dynamic>;
                  final employee = data['employee'] as Employee;
                  final records = data['records'] as List<AttendanceRecord>;

                  int presentCount = 0;
                  int absentCount = 0;
                  int halfDayCount = 0;
                  int leaveCount = 0;

                  for (var record in records) {
                    switch (record.status) {
                      case AttendanceStatus.present:
                        presentCount++;
                        break;
                      case AttendanceStatus.absent:
                        absentCount++;
                        break;
                      case AttendanceStatus.halfDay:
                        halfDayCount++;
                        break;
                      case AttendanceStatus.leave:
                        leaveCount++;
                        break;
                    }
                  }

                  final wage = employee.dailyWage ?? 0;
                  final estimatedWage = (presentCount * wage) + (halfDayCount * wage * 0.5);

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.amber[100],
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Note: Estimated wage is for internal tracking only and is not a formal payroll calculation.',
                                style: TextStyle(color: Colors.amber[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Summary for ${DateFormat('MMMM yyyy').format(_selectedMonth)}', style: Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatBox(context, 'Present', presentCount, Colors.green),
                                    _buildStatBox(context, 'Absent', absentCount, Colors.red),
                                    _buildStatBox(context, 'Half Day', halfDayCount, Colors.orange),
                                    _buildStatBox(context, 'Leave', leaveCount, Colors.blue),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                if (employee.dailyWage != null)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Estimated Wage:', style: Theme.of(context).textTheme.titleMedium),
                                        Text('₹${estimatedWage.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green[800])),
                                      ],
                                    ),
                                  )
                                else
                                  const Text('No daily wage set for this employee.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            // Sort records descending
                            final sortedRecords = records.toList()..sort((a, b) => b.date.compareTo(a.date));
                            final record = sortedRecords[index];
                            return ListTile(
                              title: Text(DateFormat('EEEE, dd MMM yyyy').format(record.date)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(label: Text(record.status.name.toUpperCase())),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDeleteRecord(context, record),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String label, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
