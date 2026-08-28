import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';
import 'package:archive/archive_io.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:starelectricerp/core/utils/permission_util.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class CaExportTab extends ConsumerStatefulWidget {
  const CaExportTab({super.key});

  @override
  ConsumerState<CaExportTab> createState() => _CaExportTabState();
}

class _CaExportTabState extends ConsumerState<CaExportTab> {
  late DateTime _selectedMonth;
  bool _gstOnly = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month - 1, 1);
  }

  Future<void> _exportForCA() async {
    setState(() => _isExporting = true);
    try {
      final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
      final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59);

      final invRepo = ref.read(invoicesRepositoryProvider);
      final compRepo = ref.read(settingsRepositoryProvider);

      final company = await compRepo.getSettings();

      final allInvoices = await invRepo.getInvoicesByDateRange(start, end);
      final invoices = allInvoices.where((inv) {
        if (!_gstOnly) return true;
        return inv.invoice.invoiceType == InvoiceType.serviceTaxInvoice || 
               inv.invoice.invoiceType == InvoiceType.salesTaxInvoice;
      }).toList();

      if (invoices.isEmpty) {
        throw Exception("No invoices found for this period and filter.");
      }

      final archive = Archive();
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];
      final headers = ['Invoice No', 'Date', 'Customer Name', 'Taxable Value', 'CGST', 'SGST', 'Grand Total', 'Status'];
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final invoicesDir = Directory('${docsDir.path}/Star Electric Works Invoices');

      int rowIdx = 1;
      for (final inv in invoices) {
        final customerName = inv.customer.name;
        
        double taxableValue = inv.invoice.subtotal - inv.invoice.discountAmount;
        double cgstTotal = inv.invoice.cgstAmount;
        double sgstTotal = inv.invoice.sgstAmount;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx)).value = TextCellValue(inv.invoice.invoiceNo);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx)).value = TextCellValue(DateFormat('dd MMM yyyy').format(inv.invoice.invoiceDate));
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIdx)).value = TextCellValue(customerName);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIdx)).value = DoubleCellValue(taxableValue);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIdx)).value = DoubleCellValue(cgstTotal);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIdx)).value = DoubleCellValue(sgstTotal);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIdx)).value = DoubleCellValue(inv.invoice.grandTotal);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIdx)).value = TextCellValue(inv.invoice.status.name);

        rowIdx++;

        File? pdfFile;
        final signedFile = File('${invoicesDir.path}/${inv.invoice.invoiceNo}_signed.pdf');
        final draftFile = File('${invoicesDir.path}/${inv.invoice.invoiceNo}_draft.pdf');
        final normalFile = File('${invoicesDir.path}/${inv.invoice.invoiceNo}.pdf');

        if (await signedFile.exists()) {
          pdfFile = signedFile;
        } else if (await normalFile.exists()) {
          pdfFile = normalFile;
        } else if (await draftFile.exists()) {
          pdfFile = draftFile;
        }

        List<int> pdfBytes;
        if (pdfFile != null) {
          pdfBytes = await pdfFile.readAsBytes();
        } else {
          double totalPaid = 0;
          if (inv.invoice.status == InvoiceStatus.paid || inv.invoice.status == InvoiceStatus.partiallyPaid) {
            final pmts = await invRepo.getPaymentsForInvoice(inv.invoice.id);
            totalPaid = pmts.fold(0, (sum, p) => sum + p.amount);
          }
          final items = await invRepo.getItemsForInvoice(inv.invoice.id);
          pdfBytes = await InvoicePdfGenerator.generate(
            company: company,
            invoice: inv.invoice,
            items: items,
            customer: inv.customer,
            totalPaid: totalPaid,
            copyLabels: ['Original for Recipient', 'Duplicate for Transporter', 'Triplicate for Supplier'],
          );
        }

        archive.addFile(ArchiveFile('${inv.invoice.invoiceNo}.pdf', pdfBytes.length, pdfBytes));
      }

      final excelBytes = excel.save();
      if (excelBytes != null) {
        archive.addFile(ArchiveFile('Summary_${DateFormat('MMMM_yyyy').format(_selectedMonth)}.xlsx', excelBytes.length, excelBytes));
      }

      final zipEncoder = ZipEncoder();
      final zipBytes = zipEncoder.encode(archive);
      if (zipBytes == null) throw Exception("Failed to encode ZIP archive");

      final hasPermission = await PermissionUtil.requestStoragePermission();
      if (!hasPermission) throw Exception('Storage permission denied');

      final zipFileName = 'Invoices_${DateFormat('MMMM_yyyy').format(_selectedMonth)}.zip';
      
      final Uri? selectedFilePath = await FilePicker.saveFile(
        dialogTitle: 'Save CA Export Zip',
        fileName: zipFileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: Uint8List.fromList(zipBytes),
      );

      if (context.mounted) {
        if (selectedFilePath != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported successfully to: ${selectedFilePath.toFilePath()}')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export cancelled.')));
        }
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Failed: $e')));
      }
    } finally {
      if (context.mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.file_present_rounded, color: Colors.blue.shade700, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Export Invoices for CA', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const Text('Generate a ZIP file with PDFs and an Excel summary.'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: _isExporting ? null : _previousMonth, icon: const Icon(Icons.chevron_left)),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedMonth),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    IconButton(onPressed: _isExporting ? null : _nextMonth, icon: const Icon(Icons.chevron_right)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SwitchListTile(
                    title: const Text('GST Relevant Only'),
                    subtitle: const Text('Includes only Service & Sales Tax Invoices'),
                    value: _gstOnly,
                    onChanged: _isExporting ? null : (val) => setState(() => _gstOnly = val),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                AppButton(
                  label: _isExporting ? 'Generating...' : 'Export for CA',
                  onPressed: _isExporting ? null : _exportForCA,
                  variant: AppButtonVariant.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
