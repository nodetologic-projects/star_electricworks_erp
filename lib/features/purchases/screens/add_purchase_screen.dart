import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/purchases_repository.dart';
import 'package:starelectricerp/data/repositories/cashbook_repository.dart';

class AddPurchaseScreen extends ConsumerStatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  ConsumerState<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends ConsumerState<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _gstController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _purchaseDate = DateTime.now();
  String _category = 'Tools';
  PaymentMode? _paymentMode;
  bool _logInCashbook = false;

  final List<String> _categories = ['Tools', 'Consumables', 'Equipment', 'Services'];

  @override
  void dispose() {
    _vendorController.dispose();
    _descController.dispose();
    _amountController.dispose();
    _gstController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    final gst = double.tryParse(_gstController.text);

    final entry = PurchasesCompanion.insert(
      vendorName: _vendorController.text,
      category: _category,
      description: _descController.text,
      amount: amount,
      gstAmount: gst != null ? drift.Value(gst) : const drift.Value.absent(),
      purchaseDate: _purchaseDate,
      paymentMode: _paymentMode != null ? drift.Value(_paymentMode) : const drift.Value.absent(),
      notes: _notesController.text.isNotEmpty ? drift.Value(_notesController.text) : const drift.Value.absent(),
    );

    final repo = ref.read(purchasesRepositoryProvider);
    await repo.addPurchase(entry);

    if (_logInCashbook && _paymentMode == PaymentMode.cash) {
      final cashRepo = ref.read(cashbookRepositoryProvider);
      await cashRepo.addTransaction(CashTransactionsCompanion.insert(
        transactionDate: _purchaseDate,
        amount: amount,
        transactionType: CashTransactionType.expense,
        category: _category,
        description: drift.Value('Purchase: ${_descController.text} from ${_vendorController.text}'),
      ));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase saved.')));
      context.pop();
    }
  }

  Future<void> _addCategory() async {
    final tc = TextEditingController();
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Category'),
        content: AppTextField(label: 'Category Name', controller: tc, ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, tc.text.trim()), child: const Text('Add')),
        ],
      ),
    );
    if (res != null && res.isNotEmpty) {
      setState(() {
        if (!_categories.contains(res)) {
          _categories.add(res);
        }
        _category = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppLayout(
      currentRoute: '/purchases',
      appBar: AppBar(
        title: const Text('Add Purchase'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Purchase Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Vendor Name',
                      controller: _vendorController,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(dateFormat.format(_purchaseDate)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null) setState(() => _purchaseDate = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      value: _categories.contains(_category) ? _category : null,
                      items: [
                        ..._categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                        const DropdownMenuItem(value: '_add_new_', child: Text('+ Add new category', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (val) {
                        if (val == '_add_new_') {
                          _addCategory();
                        } else if (val != null) {
                          setState(() => _category = val);
                        }
                      },
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      label: 'Amount (₹)',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => val == null || val.isEmpty || double.tryParse(val) == null ? 'Invalid amount' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      label: 'GST Amount (₹) - Optional',
                      controller: _gstController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description / Items',
                controller: _descController,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<PaymentMode>(
                      decoration: const InputDecoration(labelText: 'Payment Mode', border: OutlineInputBorder()),
                      value: _paymentMode,
                      items: PaymentMode.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name.toUpperCase()))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _paymentMode = val;
                          if (val != PaymentMode.cash) _logInCashbook = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _paymentMode == PaymentMode.cash
                      ? CheckboxListTile(
                          title: const Text('Also log in Cash Book'),
                          subtitle: const Text('Creates an expense entry in cash book'),
                          value: _logInCashbook,
                          onChanged: (val) => setState(() => _logInCashbook = val ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Notes (Optional)',
                controller: _notesController,
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Save Purchase',
                onPressed: _save,
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
