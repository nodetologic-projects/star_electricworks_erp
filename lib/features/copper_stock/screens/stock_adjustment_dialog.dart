import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class StockAdjustmentDialog extends ConsumerStatefulWidget {
  final int stockId;
  const StockAdjustmentDialog({super.key, required this.stockId});

  @override
  ConsumerState<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends ConsumerState<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isAdjusting = false;

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _adjust(MovementType type) async {
    if (!_formKey.currentState!.validate()) return;
    
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight > 0')),
      );
      return;
    }

    setState(() => _isAdjusting = true);
    
    try {
      await ref.read(copperStockRepositoryProvider).adjustStock(
        widget.stockId, 
        weight, 
        type,
        notes: _notesController.text,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock adjusted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting stock: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAdjusting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: AlertDialog(
      title: const Text('Adjust Stock'),
      content: Form(
        key: _formKey,
          onChanged: () {
            if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
          },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: 'Weight (kg)',
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                final parsed = double.tryParse(val);
                if (parsed == null || parsed <= 0) return 'Must be > 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Notes (Optional)',
              controller: _notesController,
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAdjusting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: '− Stock Out',
          variant: AppButtonVariant.secondary,
          isLoading: _isAdjusting,
          onPressed: () => _adjust(MovementType.saleOut),
        ),
        AppButton(
          label: '+ Stock In',
          isLoading: _isAdjusting,
          onPressed: () => _adjust(MovementType.purchaseIn),
        ),
      ],
    ));
  }
}
