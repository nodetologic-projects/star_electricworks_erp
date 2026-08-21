import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class RecordPaymentDialog extends ConsumerStatefulWidget {
  final Invoice invoice;
  final double balanceDue;

  const RecordPaymentDialog({
    super.key,
    required this.invoice,
    required this.balanceDue,
  });

  @override
  ConsumerState<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends ConsumerState<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _amountController;
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  
  PaymentMode _mode = PaymentMode.cash;
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.balanceDue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      
      final companion = PaymentsCompanion.insert(
        invoiceId: widget.invoice.id,
        amount: amount,
        paymentMode: _mode,
        paymentDate: _date,
        referenceNo: drift.Value(_referenceController.text.trim().isEmpty ? null : _referenceController.text.trim()),
        notes: drift.Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      );
      
      await repo.addPayment(companion);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatPaymentMode(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash: return 'Cash';
      case PaymentMode.bankTransfer: return 'Bank Transfer';
      case PaymentMode.upi: return 'UPI';
      case PaymentMode.cheque: return 'Cheque';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Payment'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _amountController,
                label: 'Amount (₹)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppSelect<PaymentMode>(
                label: 'Payment Mode',
                value: _mode,
                items: PaymentMode.values.map((m) => 
                  DropdownMenuItem(value: m, child: Text(_formatPaymentMode(m)))
                ).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _mode = val);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Payment Date'),
                subtitle: Text('${_date.day}/${_date.month}/${_date.year}'),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) {
                    setState(() => _date = d);
                  }
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _referenceController,
                label: 'Reference No. (Cheque / UTR)',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        AppButton(
          onPressed: _isLoading ? null : _save,
          label: 'Save Payment',
        ),
      ],
    );
  }
}
