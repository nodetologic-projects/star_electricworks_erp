import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/reports/services/tally_export_service.dart';

class TallyExportDialog extends ConsumerStatefulWidget {
  const TallyExportDialog({super.key});

  @override
  ConsumerState<TallyExportDialog> createState() => _TallyExportDialogState();
}

class _TallyExportDialogState extends ConsumerState<TallyExportDialog> {
  late DateTimeRange _dateRange;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final service = TallyExportService(repo);
      final path = await service.exportTallyExcel(
        startDate: _dateRange.start,
        endDate: _dateRange.end,
      );
      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tally Excel export saved to $path')));
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

  Future<void> _exportXml() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final service = TallyExportService(repo);
      final path = await service.exportTallyXml(
        startDate: _dateRange.start,
        endDate: _dateRange.end,
      );
      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tally XML export saved to $path')));
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
      title: const Text('Export Vouchers for Tally'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exports Sales, Credit Notes, Debit Notes, and Purchases formatted as Tally vouchers.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Period: ${DateFormat('dd MMM yyyy').format(_dateRange.start)} - ${DateFormat('dd MMM yyyy').format(_dateRange.end)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: _isExporting
                    ? null
                    : () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDateRange: _dateRange,
                        );
                        if (picked != null) {
                          setState(() => _dateRange = picked);
                        }
                      },
                child: const Text('Change Dates'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose Export Format:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.table_chart, size: 18),
          label: const Text('Export Excel'),
          onPressed: _isExporting ? null : _exportExcel,
        ),
        FilledButton.icon(
          icon: const Icon(Icons.code, size: 18),
          label: const Text('Export Tally XML'),
          onPressed: _isExporting ? null : _exportXml,
        ),
      ],
    );
  }
}
