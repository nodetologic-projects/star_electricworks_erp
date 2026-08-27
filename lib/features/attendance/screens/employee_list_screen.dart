import 'package:drift/drift.dart' as import_drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/data/database.dart';

import 'package:drift/drift.dart' as drift;

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {

  Future<void> _confirmDelete(BuildContext context, Employee employee, WidgetRef ref) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Employee?'),
        content: Text('This will hide ${employee.name} from new selections but keep historical records intact.'),
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
      final db = ref.read(databaseProvider);
      await (db.update(db.employees)..where((tbl) => tbl.id.equals(employee.id))).write(
        import_drift.EmployeesCompanion(isActive: import_drift.Value(false)),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${employee.name} deleted.')));
    }
  }


  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddEmployeeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return AppLayout(
      currentRoute: '/attendance',
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Attendance History',
            onPressed: () => context.go('/attendance/history'),
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Daily Attendance',
            onPressed: () => context.go('/attendance/daily'),
          ),
        ],
      ),
      child: StreamBuilder<List<Employee>>(
        stream: (db.select(db.employees)..where((t) => t.isActive.equals(true))).watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final employees = snapshot.data ?? [];
          if (employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No employees found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddEmployeeDialog,
                    child: const Text('+ Add Employee'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return ListTile(
                title: Text(employee.name),
                subtitle: Text(
                  '${employee.role ?? 'No Role'} • ${employee.phone ?? 'No Phone'} • Wage: ₹${employee.dailyWage ?? 0}',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: employee.isActive ? Colors.green[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    employee.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: employee.isActive ? Colors.green[800] : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                onTap: () {
                  // Edit employee dialog
                  showDialog(
                    context: context,
                    builder: (context) => AddEmployeeDialog(employee: employee),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AddEmployeeDialog extends ConsumerStatefulWidget {
  final Employee? employee;
  const AddEmployeeDialog({super.key, this.employee});

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;
  late TextEditingController _wageController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _roleController = TextEditingController(text: widget.employee?.role ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _wageController = TextEditingController(text: widget.employee?.dailyWage?.toString() ?? '');
    _isActive = widget.employee?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);
    final name = _nameController.text;
    final role = _roleController.text.isEmpty ? null : _roleController.text;
    final phone = _phoneController.text.isEmpty ? null : _phoneController.text;
    final wage = double.tryParse(_wageController.text);

    if (widget.employee == null) {
      await db.into(db.employees).insert(EmployeesCompanion.insert(
        name: name,
        role: drift.Value(role),
        phone: drift.Value(phone),
        dailyWage: drift.Value(wage),
        joiningDate: DateTime.now(),
        isActive: drift.Value(_isActive),
      ));
    } else {
      await (db.update(db.employees)..where((tbl) => tbl.id.equals(widget.employee!.id))).write(
        EmployeesCompanion(
          name: drift.Value(name),
          role: drift.Value(role),
          phone: drift.Value(phone),
          dailyWage: drift.Value(wage),
          isActive: drift.Value(_isActive),
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _wageController,
                decoration: const InputDecoration(labelText: 'Daily Wage (₹)'),
                keyboardType: TextInputType.number,
              ),
              if (widget.employee != null)
                SwitchListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
