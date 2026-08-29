import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/reports/services/ca_export_service.dart';

class CAExportDialog extends ConsumerStatefulWidget {
  const CAExportDialog({super.key});

  @override
  ConsumerState<CAExportDialog> createState() => _CAExportDialogState();
}

class _CAExportDialogState extends ConsumerState<CAExportDialog> {
  DateTime _selectedMonth = DateTime.now();
  bool _gstOnly = true;
  bool _isExporting = false;

  Future<void> _doExport() async {
    setState(() => _isExporting = true);
    
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final service = CAExportService(repo);
      final error = await service.exportInvoicesZip(_selectedMonth, _gstOnly);
      
      if (mounted) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Export Zip created successfully!')));
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Invoices for CA'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Month:'),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${_selectedMonth.year} - ${_selectedMonth.month.toString().padLeft(2, '0')}'),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedMonth,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _selectedMonth = date);
                  }
                },
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('GST Relevant Invoices Only'),
            subtitle: const Text('Excludes Bill of Supply, Challans, Proformas'),
            value: _gstOnly,
            onChanged: (val) => setState(() => _gstOnly = val ?? true),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isExporting ? null : _doExport,
          child: _isExporting 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Export ZIP'),
        ),
      ],
    );
  }
}
