import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/repositories/cashbook_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  
  CashTransactionType _type = CashTransactionType.income;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  String? _selectedCategory;
  
  bool _isLoading = false;

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
        title: const Text('Add New Category'),
        content: AppTextField(
          controller: controller,
          label: 'Category Name',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (newCategory != null && mounted) {
      final repo = ref.read(cashbookRepositoryProvider);
      await repo.addCategory(newCategory);
      setState(() {
        _selectedCategory = newCategory;
      });
      // Refresh categories (will be handled by Riverpod provider in actual screen, 
      // but here we just need it in the dropdown. To keep it simple, we use a FutureBuilder 
      // or similar, but let's just trigger a rebuild of the FutureBuilder)
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
      
      final companion = CashTransactionsCompanion.insert(
        transactionType: _type,
        amount: amount,
        category: _selectedCategory!,
        transactionDate: _date,
        description: drift.Value(_descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim()),
      );
      
      await repo.addTransaction(companion);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(cashbookRepositoryProvider);

    return AlertDialog(
      title: const Text('Add Cash Transaction'),
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
                onSelectionChanged: (set) {
                  setState(() => _type = set.first);
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _amountController,
                label: 'Amount (₹)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<CashCategory>>(
                future: repo.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  
                  final cats = snapshot.data!;
                  return AppSelect<String?>(
                    label: 'Category',
                    value: _selectedCategory,
                    items: [
                      ...cats.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))),
                      const DropdownMenuItem(value: '__ADD_NEW__', child: Text('+ Add new category', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    ],
                    onChanged: (val) {
                      if (val == '__ADD_NEW__') {
                        _addCategory();
                      } else {
                        setState(() => _selectedCategory = val);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
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
          label: 'Save',
        ),
      ],
    );
  }
}
