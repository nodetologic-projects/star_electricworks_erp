import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_date_field.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/rich_text_input.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/motor_jobs_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';
import 'package:starelectricerp/features/motor_jobs/providers/motor_jobs_provider.dart';

class MotorJobFormScreen extends ConsumerStatefulWidget {
  final int? jobId;
  const MotorJobFormScreen({super.key, this.jobId});

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
  
  DateTime _dateReceived = IstDateUtils.nowIst();
  DateTime? _gpDate;
  DateTime? _dispatchDate;

  bool _isSaving = false;
  bool _isLoading = false;
  String? _existingJobNo;
  MotorJobStatus? _existingStatus;

  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) {
      _loadJob();
    }
  }

  Future<void> _loadJob() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(motorJobsRepositoryProvider);
      final job = await repo.getMotorJobById(widget.jobId!);
      if (mounted) {
        setState(() {
          _existingJobNo = job.jobNo;
          _existingStatus = job.status;
          _selectedCustomerId = job.customerId;
          _motorDescController.text = job.motorDescription;
          _motorMakeController.text = job.motorMake ?? '';
          _hpController.text = job.hp != null ? job.hp.toString() : '';
          _selectedPhase = job.phase;
          _jobDescController.text = job.jobDescription;
          _sacCodeController.text = job.sacCode ?? '';
          _gpNumberController.text = job.gpNumber ?? '';
          _dateReceived = IstDateUtils.toMidnightIst(job.dateReceived);
          _gpDate = job.gpDate != null ? IstDateUtils.toMidnightIst(job.gpDate!) : null;
          _dispatchDate = job.dispatchDate != null ? IstDateUtils.toMidnightIst(job.dispatchDate!) : null;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a customer')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(motorJobsRepositoryProvider);
      final normalizedDateReceived = IstDateUtils.toMidnightIst(_dateReceived);
      final normalizedGpDate = _gpDate != null ? IstDateUtils.toMidnightIst(_gpDate!) : null;
      final normalizedDispatchDate = _dispatchDate != null ? IstDateUtils.toMidnightIst(_dispatchDate!) : null;

      if (widget.jobId != null) {
        final companion = MotorJobsCompanion(
          id: drift.Value(widget.jobId!),
          jobNo: drift.Value(_existingJobNo!),
          customerId: drift.Value(_selectedCustomerId!),
          motorDescription: drift.Value(_motorDescController.text),
          motorMake: drift.Value(_motorMakeController.text.isNotEmpty ? _motorMakeController.text : null),
          hp: drift.Value(_hpController.text.isNotEmpty ? double.tryParse(_hpController.text) : null),
          phase: drift.Value(_selectedPhase),
          dateReceived: drift.Value(normalizedDateReceived),
          jobDescription: drift.Value(_jobDescController.text),
          sacCode: drift.Value(_sacCodeController.text.isNotEmpty ? _sacCodeController.text.trim() : null),
          gpNumber: drift.Value(_gpNumberController.text.isNotEmpty ? _gpNumberController.text.trim() : null),
          gpDate: drift.Value(normalizedGpDate),
          dispatchDate: drift.Value(normalizedDispatchDate),
          status: drift.Value(_existingStatus ?? MotorJobStatus.received),
        );
        await repo.updateMotorJob(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job updated successfully!'), backgroundColor: AppTheme.successGreen),
          );
          context.go('/jobs/${widget.jobId}');
        }
      } else {
        final jobNo = await ref.read(motorJobAutoNumberProvider.future);
        final companion = MotorJobsCompanion.insert(
          jobNo: jobNo,
          customerId: _selectedCustomerId!,
          motorDescription: _motorDescController.text,
          motorMake: _motorMakeController.text.isNotEmpty
              ? drift.Value(_motorMakeController.text)
              : const drift.Value.absent(),
          hp: _hpController.text.isNotEmpty
              ? drift.Value(double.tryParse(_hpController.text))
              : const drift.Value.absent(),
          phase: _selectedPhase != null
              ? drift.Value(_selectedPhase!)
              : const drift.Value.absent(),
          dateReceived: normalizedDateReceived,
          jobDescription: _jobDescController.text,
          sacCode: _sacCodeController.text.isNotEmpty
              ? drift.Value(_sacCodeController.text.trim())
              : const drift.Value.absent(),
          gpNumber: _gpNumberController.text.isNotEmpty
              ? drift.Value(_gpNumberController.text.trim())
              : const drift.Value.absent(),
          gpDate: drift.Value(normalizedGpDate),
          dispatchDate: drift.Value(normalizedDispatchDate),
          status: MotorJobStatus.received,
        );

        final id = await repo.insertMotorJob(companion);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job created successfully!'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          context.go('/jobs/$id');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving job: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _hasUnsavedChanges = false);
      if (mounted) setState(() => _isSaving = false);
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
            content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Discard',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
              ),
            ],
          ),
        );
        if (shouldPop ?? false) {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: AppLayout(
        currentRoute: '/jobs/new',
        appBar: AppBar(
          title: Text(widget.jobId != null ? 'Edit Motor Job' : 'New Motor Job Entry'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppButton(
                label: widget.jobId != null ? 'Update Job' : 'Save Job',
                isLoading: _isSaving,
                onPressed: _saveJob,
              ),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              if (!_hasUnsavedChanges) {
                setState(() => _hasUnsavedChanges = true);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Information',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        customersAsync.when(
                          data: (customers) => AppSelect<int>(
                            label: 'Customer *',
                            value: _selectedCustomerId,
                            items: customers
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => _selectedCustomerId = val);
                            },
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text('Error loading customers: $e'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dates',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppDateField(
                                label: 'Date Received *',
                                value: _dateReceived,
                                isRequired: true,
                                onChanged: (d) {
                                  if (d != null) {
                                    setState(() => _dateReceived = IstDateUtils.toMidnightIst(d));
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppDateField(
                                label: 'Gate Pass Date',
                                value: _gpDate,
                                onChanged: (d) {
                                  setState(() => _gpDate = d != null ? IstDateUtils.toMidnightIst(d) : null);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppDateField(
                                label: 'Dispatch Date (Optional)',
                                value: _dispatchDate,
                                onChanged: (d) {
                                  setState(() => _dispatchDate = d != null ? IstDateUtils.toMidnightIst(d) : null);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Motor Details',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Motor Description *',
                          hintText: 'e.g. Induction Motor, Submersible Pump',
                          controller: _motorDescController,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Motor description is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Make / Brand',
                                hintText: 'e.g. Kirloskar, Crompton',
                                controller: _motorMakeController,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppTextField(
                                label: 'HP / Power',
                                hintText: 'e.g. 5.0, 7.5',
                                controller: _hpController,
                                keyboardType: const TextInputType
                                    .numberWithOptions(decimal: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppSelect<Phase>(
                          label: 'Phase',
                          value: _selectedPhase,
                          items: Phase.values
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    p == Phase.single
                                        ? 'Single Phase'
                                        : 'Three Phase',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedPhase = val),
                        ),
                        const SizedBox(height: 16),
                        RichTextInput(
                          label: 'Job Description *',
                          hintText: 'Describe the work to be done...',
                          controller: _jobDescController,
                          maxLines: 4,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Job description is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'SAC/HSN Code (Optional)',
                          hintText: 'Service Accounting Code',
                          controller: _sacCodeController,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Gate Pass Number (Optional)',
                          controller: _gpNumberController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
