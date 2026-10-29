import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_date_field.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class RecordPaymentDialog extends ConsumerStatefulWidget {
  final Invoice invoice;
  final double balanceDue;
  final Payment? existingPayment;

  const RecordPaymentDialog({
    super.key,
    required this.invoice,
    required this.balanceDue,
    this.existingPayment,
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
  DateTime _date = IstDateUtils.nowIst();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingPayment != null) {
      final p = widget.existingPayment!;
      _amountController = TextEditingController(text: p.amount.toStringAsFixed(2));
      _referenceController.text = p.referenceNo ?? '';
      _notesController.text = p.notes ?? '';
      _mode = p.paymentMode;
      _date = IstDateUtils.toMidnightIst(p.paymentDate);
    } else {
      _amountController = TextEditingController(text: widget.balanceDue.toStringAsFixed(2));
      _date = IstDateUtils.nowIst();
    }
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
      
      final normalizedDate = IstDateUtils.toMidnightIst(_date);
      if (widget.existingPayment != null) {
        final companion = PaymentsCompanion(
          id: drift.Value(widget.existingPayment!.id),
          invoiceId: drift.Value(widget.invoice.id),
          amount: drift.Value(amount),
          paymentMode: drift.Value(_mode),
          paymentDate: drift.Value(normalizedDate),
          referenceNo: drift.Value(_referenceController.text.trim().isEmpty ? null : _referenceController.text.trim()),
          notes: drift.Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        );
        await repo.updatePayment(companion);
      } else {
        final companion = PaymentsCompanion.insert(
          invoiceId: widget.invoice.id,
          amount: amount,
          paymentMode: _mode,
          paymentDate: normalizedDate,
          referenceNo: drift.Value(_referenceController.text.trim().isEmpty ? null : _referenceController.text.trim()),
          notes: drift.Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        );
        await repo.addPayment(companion);
      }
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
    final invDate = IstDateUtils.toMidnightIst(widget.invoice.invoiceDate);
    final isBeforeInvoice = _date.isBefore(invDate);
    final isFuture = _date.isAfter(IstDateUtils.nowIst());

    return AlertDialog(
      title: Text(widget.existingPayment != null ? 'Edit Payment' : 'Record Payment'),
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
              AppDateField(
                label: 'Payment Date *',
                value: _date,
                isRequired: true,
                onChanged: (d) {
                  if (d != null) {
                    setState(() => _date = IstDateUtils.toMidnightIst(d));
                  }
                },
              ),
              if (isBeforeInvoice || isFuture) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isBeforeInvoice)
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 16, color: Colors.amber.shade900),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Payment date is before the invoice date (${IstDateUtils.format(widget.invoice.invoiceDate)})',
                                style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      if (isFuture) ...[
                        if (isBeforeInvoice) const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.amber.shade900),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Payment is future-dated',
                                style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
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
          label: widget.existingPayment != null ? 'Update Payment' : 'Save Payment',
        ),
      ],
    );
  }
}
