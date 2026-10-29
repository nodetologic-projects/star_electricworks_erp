import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/widgets/app_date_field.dart';
import 'package:starelectricerp/core/utils/permission_util.dart';
import 'package:starelectricerp/core/services/direct_print_service.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/customers/ledger/customer_ledger_pdf.dart';

enum LedgerDateRangePreset {
  currentFY,
  allTime,
  custom,
}

class CustomerLedgerExportDialog extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerLedgerExportDialog({super.key, required this.customerId});

  @override
  ConsumerState<CustomerLedgerExportDialog> createState() => _CustomerLedgerExportDialogState();
}

class _CustomerLedgerExportDialogState extends ConsumerState<CustomerLedgerExportDialog> {
  LedgerDateRangePreset _preset = LedgerDateRangePreset.currentFY;
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final now = IstDateUtils.nowIst();
    final fyYear = now.month >= 4 ? now.year : now.year - 1;
    _fromDate = DateTime(fyYear, 4, 1);
    _toDate = now;
  }

  void _onPresetChanged(LedgerDateRangePreset? preset) {
    if (preset == null) return;
    setState(() {
      _preset = preset;
      final now = IstDateUtils.nowIst();
      if (preset == LedgerDateRangePreset.currentFY) {
        final fyYear = now.month >= 4 ? now.year : now.year - 1;
        _fromDate = DateTime(fyYear, 4, 1);
        _toDate = now;
      } else if (preset == LedgerDateRangePreset.allTime) {
        _toDate = now;
      }
    });
  }

  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim().replaceAll(' ', '_');
  }

  Future<void> _exportLedger() async {
    setState(() => _isExporting = true);

    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final DateTime? fromDate = _preset == LedgerDateRangePreset.allTime ? null : _fromDate;
      final DateTime toDate = _toDate;

      if (fromDate != null && toDate.isBefore(fromDate)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('To Date cannot be before From Date.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final statement = await repo.getCustomerLedgerStatement(
        customerId: widget.customerId,
        fromDate: fromDate,
        toDate: toDate,
      );

      // Empty range check: show a clear message instead of generating an empty PDF
      if (statement.openingBalance == 0.0 && statement.entries.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No transactions or balance found for the selected period.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final bytes = await CustomerLedgerPdfGenerator.generate(statement: statement);

      final hasPermission = await PermissionUtil.requestStoragePermission();
      if (!hasPermission) throw Exception('Storage permission denied');

      final docsDir = await getApplicationDocumentsDirectory();
      final ledgersDir = Directory(p.join(docsDir.path, 'Star Electric Works Invoices', 'Ledgers'));
      if (!await ledgersDir.exists()) {
        await ledgersDir.create(recursive: true);
      }

      final safeName = _sanitizeFileName(statement.customer.name);
      final dateFmt = DateFormat('dd-MM-yyyy');
      final fromStr = statement.fromDate != null ? dateFmt.format(statement.fromDate!) : 'All_Time';
      final toStr = dateFmt.format(statement.toDate);
      final fileName = 'Ledger_${safeName}_${fromStr}_to_$toStr.pdf';

      final file = File(p.join(ledgersDir.path, fileName));
      await file.writeAsBytes(bytes);

      if (mounted) {
        Navigator.of(context).pop(); // Close export setup dialog

        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => CustomerLedgerPreviewDialog(
            customerName: statement.customer.name,
            fileName: fileName,
            file: file,
            pdfBytes: bytes,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export ledger: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = IstDateUtils.nowIst();
    final fyYear = now.month >= 4 ? now.year : now.year - 1;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.red),
          SizedBox(width: 8),
          Text('Export Ledger (PDF)'),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select statement period:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<LedgerDateRangePreset>(
                  segments: const [
                    ButtonSegment(
                      value: LedgerDateRangePreset.currentFY,
                      label: Text('Current FY'),
                      icon: Icon(Icons.calendar_today, size: 16),
                    ),
                    ButtonSegment(
                      value: LedgerDateRangePreset.allTime,
                      label: Text('All Time'),
                      icon: Icon(Icons.all_inclusive, size: 16),
                    ),
                    ButtonSegment(
                      value: LedgerDateRangePreset.custom,
                      label: Text('Custom'),
                      icon: Icon(Icons.date_range, size: 16),
                    ),
                  ],
                  selected: {_preset},
                  onSelectionChanged: (set) => _onPresetChanged(set.first),
                ),
              ),
              const SizedBox(height: 16),
              if (_preset == LedgerDateRangePreset.currentFY)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Period: 01/04/$fyYear to ${DateFormat('dd/MM/yyyy').format(now)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
              if (_preset != LedgerDateRangePreset.allTime) ...[
                AppDateField(
                  label: 'From Date *',
                  value: _fromDate,
                  isRequired: true,
                  enabled: _preset == LedgerDateRangePreset.custom,
                  onChanged: (d) {
                    if (d != null) setState(() => _fromDate = IstDateUtils.toMidnightIst(d));
                  },
                ),
                const SizedBox(height: 12),
              ],
              AppDateField(
                label: _preset == LedgerDateRangePreset.allTime ? 'Up to Date *' : 'To Date *',
                value: _toDate,
                isRequired: true,
                enabled: _preset == LedgerDateRangePreset.custom,
                onChanged: (d) {
                  if (d != null) setState(() => _toDate = IstDateUtils.toMidnightIst(d));
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'PDF will be saved to "Star Electric Works Invoices/Ledgers" folder. Drafts, Delivery Challans & Purchase Vouchers are excluded.',
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isExporting ? null : _exportLedger,
          icon: _isExporting
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.picture_as_pdf, size: 16),
          label: const Text('Export Statement'),
        ),
      ],
    );
  }
}

class CustomerLedgerPreviewDialog extends StatelessWidget {
  final String customerName;
  final String fileName;
  final File file;
  final Uint8List pdfBytes;

  const CustomerLedgerPreviewDialog({
    super.key,
    required this.customerName,
    required this.fileName,
    required this.file,
    required this.pdfBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 850),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statement of Account — $customerName',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Saved to: ${file.path}',
                          style: TextStyle(fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
                        },
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Save / Share'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async => pdfBytes,
                            name: fileName,
                          );
                        },
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print'),
                      ),
                      FilledButton.icon(
                        onPressed: () async {
                          await DirectPrintService.printPdf(
                            context,
                            fileName,
                            fallbackGenerate: () async => pdfBytes,
                            explicitPdfPath: file.path,
                          );
                        },
                        icon: const Icon(Icons.print_rounded, size: 16),
                        label: const Text('Direct Print'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PdfPreview(
                build: (format) async => pdfBytes,
                allowPrinting: false,
                allowSharing: false,
                canChangeOrientation: false,
                canChangePageFormat: false,
                initialPageFormat: PdfPageFormat.a4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
