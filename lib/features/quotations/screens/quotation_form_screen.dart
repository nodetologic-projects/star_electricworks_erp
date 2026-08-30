import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/rich_text_input.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';
import 'package:intl/intl.dart';

class QuotationFormScreen extends ConsumerStatefulWidget {
  const QuotationFormScreen({super.key});

  @override
  ConsumerState<QuotationFormScreen> createState() => _QuotationFormScreenState();
}

class _QuotationFormScreenState extends ConsumerState<QuotationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedCustomerId;
  bool _isProspective = false;
  final _prospectiveNameCtrl = TextEditingController();
  final _prospectivePhoneCtrl = TextEditingController();
  
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  
  DateTime? _validUntil;

  @override
  void dispose() {
    _prospectiveNameCtrl.dispose();
    _prospectivePhoneCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_isProspective && _prospectiveNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter prospective customer name')));
      return;
    }
    
    if (!_isProspective && _selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a customer')));
      return;
    }

    final repo = ref.read(quotationsRepositoryProvider);
    
    final companion = QuotationsCompanion(
      customerId: _isProspective ? const drift.Value.absent() : drift.Value(_selectedCustomerId),
      prospectiveCustomerName: _isProspective ? drift.Value(_prospectiveNameCtrl.text.trim()) : const drift.Value.absent(),
      prospectiveCustomerPhone: _isProspective ? drift.Value(_prospectivePhoneCtrl.text.trim()) : const drift.Value.absent(),
      description: drift.Value(_descCtrl.text.trim()),
      estimatedAmount: drift.Value(double.parse(_amountCtrl.text)),
      validUntil: drift.Value(_validUntil),
    );

    await repo.insertQuotation(companion);
    
    // Invalidate list
    ref.invalidate(quotationsRepositoryProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quotation Created')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersStreamProvider);

    return AppLayout(
      currentRoute: '/quotations',
      appBar: AppBar(
        title: const Text('New Quotation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Prospective / Unsaved Customer?'),
                        value: _isProspective,
                        onChanged: (val) => setState(() {
                          _isProspective = val;
                          if (val) _selectedCustomerId = null;
                        }),
                      ),
                      if (!_isProspective)
                        customersAsync.when(
                          data: (customers) => DropdownButtonFormField<int>(
                            decoration: const InputDecoration(labelText: 'Select Customer', border: OutlineInputBorder()),
                            initialValue: _selectedCustomerId,
                            items: customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                            onChanged: (val) => setState(() => _selectedCustomerId = val),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, s) => Text('Error: $e'),
                        )
                      else ...[
                        AppTextField(
                          controller: _prospectiveNameCtrl,
                          label: 'Name',
                          hintText: 'Customer Name',
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _prospectivePhoneCtrl,
                          label: 'Phone (Optional)',
                          hintText: 'e.g. 9876543210',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quotation Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      RichTextInput(
                        controller: _descCtrl,
                        label: 'Description / Scope of Work',
                        hintText: 'Rewinding of 10HP Motor...',
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _amountCtrl,
                              label: 'Estimated Amount (₹)',
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Required';
                                if (double.tryParse(val) == null) return 'Invalid number';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _validUntil ?? DateTime.now().add(const Duration(days: 15)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _validUntil = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Valid Until (Optional)', border: OutlineInputBorder()),
                                child: Text(_validUntil != null ? DateFormat('dd/MM/yyyy').format(_validUntil!) : 'Select Date'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save Quotation'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
