import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

final copperStockDetailProvider = FutureProvider.autoDispose.family<CopperStockData?, int?>((ref, id) async {
  if (id == null) return null;
  final repo = ref.watch(copperStockRepositoryProvider);
  return repo.getCopperStockById(id);
});

class CopperStockFormScreen extends ConsumerStatefulWidget {
  final int? stockId;
  const CopperStockFormScreen({super.key, this.stockId});

  @override
  ConsumerState<CopperStockFormScreen> createState() => _CopperStockFormScreenState();
}

class _CopperStockFormScreenState extends ConsumerState<CopperStockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  
  CopperType _selectedType = CopperType.newCopper;
  final _descController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  double? _selectedGst = 18.0; // Default 18% GST
  final _hsnController = TextEditingController();
  final _qtyController = TextEditingController();
  final _reorderController = TextEditingController();

  bool _isSaving = false;
  bool _initialized = false;

  final List<double?> _gstOptions = [null, 0.0, 5.0, 12.0, 18.0, 28.0];

  @override
  void dispose() {
    _descController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _hsnController.dispose();
    _qtyController.dispose();
    _reorderController.dispose();
    super.dispose();
  }

  void _initFields(CopperStockData? data) {
    if (_initialized) return;
    if (data != null) {
      _selectedType = data.copperType;
      _descController.text = data.description;
      _weightController.text = data.weightKg.toString();
      _priceController.text = data.pricePerKg.toString();
      _selectedGst = data.gstRate;
      _hsnController.text = data.hsnCode ?? '';
      _qtyController.text = data.stockQtyKg.toString();
      _reorderController.text = data.reorderLevelKg?.toString() ?? '';
    }
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final companion = CopperStockCompanion(
        copperType: drift.Value(_selectedType),
        description: drift.Value(_descController.text),
        weightKg: drift.Value(double.parse(_weightController.text)),
        pricePerKg: drift.Value(double.parse(_priceController.text)),
        gstRate: drift.Value(_selectedGst),
        hsnCode: _hsnController.text.isNotEmpty ? drift.Value(_hsnController.text) : const drift.Value.absent(),
        reorderLevelKg: _reorderController.text.isNotEmpty ? drift.Value(double.parse(_reorderController.text)) : const drift.Value.absent(),
      );

      final repo = ref.read(copperStockRepositoryProvider);
      
      if (widget.stockId == null) {
        // Create
        final insertCompanion = companion.copyWith(
          stockQtyKg: drift.Value(double.parse(_qtyController.text)),
        );
        await repo.insertCopperStock(insertCompanion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock created successfully')));
          context.go('/stock');
        }
      } else {
        // Update (qty is ignored as it is read-only in UI)
        final updateCompanion = companion.copyWith(
          id: drift.Value(widget.stockId!),
        );
        await repo.updateCopperStock(updateCompanion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock updated successfully')));
          context.go('/stock');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving stock: $e')));
      }
    } finally {
      if (mounted) if (mounted) setState(() => _hasUnsavedChanges = false);
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(copperStockDetailProvider(widget.stockId));
    final isEditing = widget.stockId != null;

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
      currentRoute: '/stock',
      appBar: AppBar(title: const Text('Copper Stock Form')),
      child: stockAsync.when(
              data: (data) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _initFields(data);
                });

                return SingleChildScrollView(
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
                              onPressed: () => context.go('/stock'),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEditing ? 'Edit Stock' : 'New Stock Entry',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Spacer(),
                            AppButton(
                              label: 'Save',
                              onPressed: _save,
                              isLoading: _isSaving,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppSelect<CopperType>(
                                label: 'Copper Type *',
                                value: _selectedType,
                                items: const [
                                  DropdownMenuItem(value: CopperType.newCopper, child: Text('New Copper')),
                                  DropdownMenuItem(value: CopperType.oldCopper, child: Text('Old Copper / Scrap')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedType = val);
                                },
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                label: 'Description *',
                                hintText: 'e.g. 18 SWG New Copper Wire',
                                controller: _descController,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Standard Weight (kg) *',
                                      controller: _weightController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) return 'Required';
                                        if (double.tryParse(val) == null || double.parse(val) <= 0) return 'Must be > 0';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Price per kg (₹) *',
                                      controller: _priceController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) return 'Required';
                                        if (double.tryParse(val) == null || double.parse(val) <= 0) return 'Must be > 0';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppSelect<double?>(
                                      label: 'GST Rate *',
                                      value: _selectedGst,
                                      items: _gstOptions.map((gst) {
                                        return DropdownMenuItem(
                                          value: gst,
                                          child: Text(gst == null ? 'No GST' : '${gst.toStringAsFixed(0)}%'),
                                        );
                                      }).toList(),
                                      onChanged: (val) => setState(() => _selectedGst = val),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      label: 'HSN Code',
                                      controller: _hsnController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: isEditing ? 'Stock Qty (kg) - Use Adjustment Dialog' : 'Initial Stock Qty (kg) *',
                                      controller: _qtyController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) return 'Required';
                                        if (double.tryParse(val) == null || double.parse(val) < 0) return 'Must be >= 0';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Reorder Level (kg)',
                                      controller: _reorderController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    ),
                                  ),
                                ],
                              ),
                              if (isEditing)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Note: Stock quantity cannot be manually edited here after creation. Please use the Stock Adjustment dialog to record inward/outward movements.',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    ));
  }
}
