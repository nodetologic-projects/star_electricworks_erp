import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/cashbook_repository.dart';
import 'package:starelectricerp/data/repositories/purchases_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:drift/drift.dart' as drift;

class PurchaseItemData {
  String category = 'Raw Material';
  String description = '';
  double amount = 0.0;
  double gstAmount = 0.0;
}

class AddPurchaseScreen extends ConsumerStatefulWidget {
  final int? purchaseId;
  const AddPurchaseScreen({super.key, this.purchaseId});

  @override
  ConsumerState<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends ConsumerState<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _purchaseDate = DateTime.now();
  PaymentMode? _paymentMode = PaymentMode.cash;
  bool _logInCashbook = true;
  bool _isEditing = false;
  
  List<PurchaseItemData> _items = [PurchaseItemData()];
  
  @override
  void initState() {
    super.initState();
    if (widget.purchaseId != null) {
      _isEditing = true;
      _loadPurchase();
    }
  }

  Future<void> _loadPurchase() async {
    final db = ref.read(databaseProvider);
    final purchase = await (db.select(db.purchases)..where((t) => t.id.equals(widget.purchaseId!))).getSingle();
    final items = await (db.select(db.purchaseItems)..where((t) => t.purchaseId.equals(widget.purchaseId!))).get();

    if (mounted) {
      setState(() {
        _vendorController.text = purchase.vendorName ?? '';
        _notesController.text = purchase.notes ?? '';
        _purchaseDate = purchase.purchaseDate;
        _paymentMode = purchase.paymentMode;
        _logInCashbook = false;
        _billImagePath = purchase.billImagePath;
        
        if (items.isNotEmpty) {
          _items = items.map((e) => PurchaseItemData()
            ..category = e.category
            ..description = e.description
            ..amount = e.amount
            ..gstAmount = e.gstAmount ?? 0.0
          ).toList();
        }
      });
    }
  }
  
  List<String> _categories = [
    'Raw Material',
    'Consumables',
    'Office Supplies',
    'Transport/Freight',
    'Maintenance',
    'Other'
  ];

  String? _billImagePath;

  @override
  void dispose() {
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final targetDir = Directory('${appDir.path}/StarElectric_PurchaseBills');
      if (!await targetDir.exists()) await targetDir.create();
      
      final ext = picked.path.split('.').last;
      final fileName = 'bill_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final savedImage = await File(picked.path).copy('${targetDir.path}/$fileName');
      
      setState(() {
        _billImagePath = savedImage.path;
      });
    }
  }

  double get _totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.amount + item.gstAmount);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final purchaseEntry = PurchasesCompanion.insert(
      vendorName: _vendorController.text.trim(),
      purchaseDate: _purchaseDate,
      paymentMode: _paymentMode != null ? drift.Value(_paymentMode!) : const drift.Value.absent(),
      notes: _notesController.text.trim().isNotEmpty ? drift.Value(_notesController.text.trim()) : const drift.Value.absent(),
      billImagePath: _billImagePath != null ? drift.Value(_billImagePath!) : const drift.Value.absent(),
      totalAmount: drift.Value(_totalAmount),
    );
    
    final itemEntries = _items.map((item) => PurchaseItemsCompanion.insert(
      purchaseId: 0,
      category: item.category,
      description: item.description,
      amount: item.amount,
      gstAmount: item.gstAmount > 0 ? drift.Value(item.gstAmount) : const drift.Value.absent(),
    )).toList();

    final repo = ref.read(purchasesRepositoryProvider);
    if (_isEditing) {
      await repo.updatePurchase(purchaseEntry.copyWith(id: drift.Value(widget.purchaseId!)), itemEntries);
    } else {
      await repo.addPurchase(purchaseEntry, itemEntries);
      if (_logInCashbook && _paymentMode == PaymentMode.cash) {
        final cashRepo = ref.read(cashbookRepositoryProvider);
        await cashRepo.addTransaction(CashTransactionsCompanion.insert(
          transactionDate: _purchaseDate,
          amount: _totalAmount,
          transactionType: CashTransactionType.expense,
          category: 'Purchase',
          description: drift.Value('Purchase from ${_vendorController.text.trim()}'),
        ));
      }
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
        content: AppTextField(label: 'Category Name', controller: tc),
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
      });
      return;
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
                          value: _logInCashbook,
                          onChanged: (val) => setState(() => _logInCashbook = val ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Items', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ..._items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                                value: _categories.contains(item.category) ? item.category : null,
                                items: [
                                  ..._categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                                  const DropdownMenuItem(value: '_add_new_', child: Text('+ Add new', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                                ],
                                onChanged: (val) async {
                                  if (val == '_add_new_') {
                                    await _addCategory();
                                  } else if (val != null) {
                                    setState(() => item.category = val);
                                  }
                                },
                                validator: (val) => val == null ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                                initialValue: item.description,
                                onChanged: (val) => item.description = val,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                            ),
                            if (_items.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => setState(() => _items.removeAt(idx)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                                initialValue: item.amount > 0 ? item.amount.toString() : '',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (val) => item.amount = double.tryParse(val) ?? 0.0,
                                validator: (val) => val == null || val.isEmpty || double.tryParse(val) == null ? 'Invalid' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'GST Amount (₹)', border: OutlineInputBorder()),
                                initialValue: item.gstAmount > 0 ? item.gstAmount.toString() : '',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (val) => item.gstAmount = double.tryParse(val) ?? 0.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                onPressed: () => setState(() => _items.add(PurchaseItemData())),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Notes (Optional)',
                      controller: _notesController,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Bill Photo', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (_billImagePath != null) ...[
                Image.file(File(_billImagePath!), height: 200),
                const SizedBox(height: 8),
              ],
              OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: Text(_billImagePath == null ? 'Attach Bill Image' : 'Change Bill Image'),
                onPressed: _pickImage,
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
