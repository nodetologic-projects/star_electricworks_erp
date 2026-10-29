import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_date_field.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/repositories/cashbook_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  final CashTransaction? existingTransaction;

  const AddTransactionDialog({super.key, this.existingPayment, this.existingTransaction});

  // Backward compatibility alias
  final dynamic existingPayment;

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  
  CashTransactionType _type = CashTransactionType.income;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _date = IstDateUtils.nowIst();
  String? _selectedCategory;
  
  bool _isLoading = false;
  List<CashCategory> _categories = [];
  bool _isCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final t = widget.existingTransaction!;
      _type = t.transactionType;
      _amountController.text = t.amount.toStringAsFixed(2);
      _descriptionController.text = t.description ?? '';
      _selectedCategory = t.category;
      _date = IstDateUtils.toMidnightIst(t.transactionDate);
    } else {
      _date = IstDateUtils.nowIst();
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final repo = ref.read(cashbookRepositoryProvider);
    final cats = await repo.getCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isCategoriesLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final newCategory = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (newCategory != null && newCategory.isNotEmpty) {
      final repo = ref.read(cashbookRepositoryProvider);
      await repo.addCategory(newCategory);
      await _loadCategories();
      setState(() {
        _selectedCategory = newCategory;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(cashbookRepositoryProvider);
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final normalizedDate = IstDateUtils.toMidnightIst(_date);

      if (widget.existingTransaction != null) {
        final companion = CashTransactionsCompanion(
          id: drift.Value(widget.existingTransaction!.id),
          transactionType: drift.Value(_type),
          amount: drift.Value(amount),
          category: drift.Value(_selectedCategory!),
          transactionDate: drift.Value(normalizedDate),
          description: drift.Value(_descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim()),
        );
        await repo.updateTransaction(companion);
      } else {
        final companion = CashTransactionsCompanion.insert(
          transactionType: _type,
          amount: amount,
          category: _selectedCategory!,
          transactionDate: normalizedDate,
          description: drift.Value(_descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim()),
        );
        await repo.addTransaction(companion);
      }
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingTransaction != null ? 'Edit Cash Transaction' : 'Add Cash Transaction'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle
              SegmentedButton<CashTransactionType>(
                segments: const [
                  ButtonSegment(
                    value: CashTransactionType.income,
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_downward, color: Colors.green),
                  ),
                  ButtonSegment(
                    value: CashTransactionType.expense,
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_upward, color: Colors.red),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
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
              if (_isCategoriesLoading)
                const CircularProgressIndicator()
              else
                AppSelect<String>(
                  label: 'Category',
                  value: _selectedCategory,
                  items: [
                    ..._categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))),
                    const DropdownMenuItem(
                      value: '__ADD_NEW__',
                      child: Text('+ Add New Category...', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                  onChanged: (val) {
                    if (val == '__ADD_NEW__') {
                      _addCategory();
                    } else {
                      setState(() => _selectedCategory = val);
                    }
                  },
                ),
              const SizedBox(height: 16),
              AppDateField(
                label: 'Date *',
                value: _date,
                isRequired: true,
                onChanged: (d) {
                  if (d != null) {
                    setState(() => _date = IstDateUtils.toMidnightIst(d));
                  }
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
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
          label: widget.existingTransaction != null ? 'Update' : 'Save',
        ),
      ],
    );
  }
}
