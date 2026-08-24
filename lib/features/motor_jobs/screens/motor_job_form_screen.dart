import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/motor_jobs_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';
import 'package:starelectricerp/features/motor_jobs/providers/motor_jobs_provider.dart';

class MotorJobFormScreen extends ConsumerStatefulWidget {
  const MotorJobFormScreen({super.key});

  @override
  ConsumerState<MotorJobFormScreen> createState() => _MotorJobFormScreenState();
}

class _MotorJobFormScreenState extends ConsumerState<MotorJobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  
  int? _selectedCustomerId;
  final _motorDescController = TextEditingController();
  final _motorMakeController = TextEditingController();
  final _hpController = TextEditingController();
  Phase? _selectedPhase;
  final _jobDescController = TextEditingController();
  final _sacCodeController = TextEditingController();
  final _gpNumberController = TextEditingController();
  DateTime? _gpDate;

  bool _isSaving = false;

  @override
  void dispose() {
    _motorDescController.dispose();
    _motorMakeController.dispose();
    _hpController.dispose();
    _jobDescController.dispose();
    _sacCodeController.dispose();
    _gpNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final jobNo = await ref.read(motorJobAutoNumberProvider.future);
      
      final companion = MotorJobsCompanion.insert(
        jobNo: jobNo,
        customerId: _selectedCustomerId!,
        motorDescription: _motorDescController.text,
        motorMake: _motorMakeController.text.isNotEmpty ? drift.Value(_motorMakeController.text) : const drift.Value.absent(),
        hp: _hpController.text.isNotEmpty ? drift.Value(double.tryParse(_hpController.text)) : const drift.Value.absent(),
        phase: _selectedPhase != null ? drift.Value(_selectedPhase!) : const drift.Value.absent(),
        dateReceived: DateTime.now(),
        jobDescription: _jobDescController.text,
        sacCode: _sacCodeController.text.isNotEmpty ? drift.Value(_sacCodeController.text.trim()) : const drift.Value.absent(),
        gpNumber: _gpNumberController.text.isNotEmpty ? drift.Value(_gpNumberController.text.trim()) : const drift.Value.absent(),
        gpDate: drift.Value(_gpDate),
        status: MotorJobStatus.received,
      );

      final repo = ref.read(motorJobsRepositoryProvider);
      final id = await repo.insertMotorJob(companion);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job created successfully!'), backgroundColor: AppTheme.successGreen),
        );
        context.go('/jobs/$id');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving job: $e'), backgroundColor: AppTheme.errorRed),
        );
      }
    } finally {
      if (mounted) if (mounted) setState(() => _hasUnsavedChanges = false);
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersStreamProvider);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard', style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        if (shouldPop ?? false) {
          if (context.mounted) context.pop();
        }
      },
      child: AppLayout(
      currentRoute: '/jobs',
      appBar: AppBar(title: const Text('Motor Job Form')),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      if (_hasUnsavedChanges) {
                        final navigator = Navigator.of(context);
                        final shouldPop = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Unsaved Changes'),
                            content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (shouldPop ?? false) navigator.pop();
                      } else {
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'New Motor Job',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  AppButton(
                    label: 'Save Job',
                    onPressed: _saveJob,
                    isLoading: _isSaving,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Form fields
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customersAsync.when(
                      data: (customers) {
                        return AppSelect<int>(
                          label: 'Customer *',
                          value: _selectedCustomerId,
                          items: customers.map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedCustomerId = val),
                          validator: (val) => val == null ? 'Please select a customer' : null,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Error loading customers: $err'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Motor Description *',
                      hintText: 'e.g. 10HP 3-phase induction motor',
                      controller: _motorDescController,
                      validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Motor Make (Optional)',
                            hintText: 'e.g. Crompton',
                            controller: _motorMakeController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            label: 'HP (Optional)',
                            hintText: 'e.g. 10.5',
                            controller: _hpController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppSelect<Phase>(
                      label: 'Phase (Optional)',
                      value: _selectedPhase,
                      items: Phase.values.map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      )).toList(),
                      onChanged: (val) => setState(() => _selectedPhase = val),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Job Description *',
                      hintText: 'Describe the work to be done...',
                      controller: _jobDescController,
                      maxLines: 4,
                      validator: (val) => val == null || val.isEmpty ? 'Job description is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'SAC Code (Optional)',
                      hintText: 'Service Accounting Code',
                      controller: _sacCodeController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Gate Pass Number',
                            controller: _gpNumberController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _gpDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _gpDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Gate Pass Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _gpDate != null ? "${_gpDate!.day}/${_gpDate!.month}/${_gpDate!.year}" : 'Select Date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
