import 'dart:typed_data';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

class CAExportService {
  final InvoicesRepository repo;
  final CustomersRepository customersRepo;
  final SettingsRepository settingsRepo;
  
  CAExportService(this.repo, this.customersRepo, this.settingsRepo);

  Future<String?> exportInvoicesZip(DateTime month, bool gstOnly) async {
    // 1. Fetch invoices for the month
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    // Get all non-draft invoices, we'll filter them
    final invoices = await repo.getAllInvoices(); 
    
    final filtered = invoices.where((inv) {
      if (inv.invoiceDate.isBefore(start) || inv.invoiceDate.isAfter(end)) return false;
      if (inv.status == InvoiceStatus.draft) return false;
      if (gstOnly) {
        if (inv.invoiceType == InvoiceType.billOfSupply || 
            inv.invoiceType == InvoiceType.deliveryChallan) {
          return false;
        }
        if (inv.invoiceType.isNote &&
            inv.cgstAmount == 0 &&
            inv.sgstAmount == 0 &&
            inv.igstAmount == 0) {
          return false;
        }
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      final dateCmp = a.invoiceDate.compareTo(b.invoiceDate);
      if (dateCmp != 0) return dateCmp;
      return a.createdAt.compareTo(b.createdAt);
    });

    if (filtered.isEmpty) {
      return 'No invoices or notes found for the selected period.';
    }

    // 2. Prepare zip
    final archive = Archive();
    int addedCount = 0;
    final company = await settingsRepo.getSettings();
    
    for (var invoice in filtered) {
      Uint8List? fileBytes;
      final pdfPath = invoice.signedPdfPath;
      if (pdfPath != null && File(pdfPath).existsSync()) {
        fileBytes = await File(pdfPath).readAsBytes();
      } else {
        try {
          final items = await repo.getItemsForInvoice(invoice.id);
          final customer = await customersRepo.getCustomerById(invoice.customerId);
          Invoice? orig;
          if (invoice.originalInvoiceId != null) {
            orig = await repo.getInvoiceById(invoice.originalInvoiceId!);
          }
          fileBytes = await InvoicePdfGenerator.generate(
            company: company,
            invoice: invoice,
            items: items,
            customer: customer,
            originalInvoice: orig,
          );
        } catch (_) {
          // If generation fails for a particular invoice, continue
        }
      }

      if (fileBytes != null) {
        final fileName = '${invoice.invoiceNo.replaceAll('/', '_')}.pdf';
        final archiveFile = ArchiveFile(fileName, fileBytes.length, fileBytes);
        archive.addFile(archiveFile);
        addedCount++;
      }
    }
    
    if (addedCount == 0) {
      return 'No PDF files could be prepared for the selected invoices and notes.';
    }

    // 3. Encode zip
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);
    if (zipData == null) return 'Failed to encode zip.';

    // 4. Save via FilePicker
    final savePath = await FilePicker.saveFile(
      dialogTitle: 'Save CA Export Zip',
      fileName: 'CA_Export_${month.year}_${month.month.toString().padLeft(2, '0')}.zip',
      type: FileType.custom,
      allowedExtensions: ['zip'],
      bytes: Uint8List.fromList(zipData),
    );
    
    if (savePath != null) {
      final f = File(savePath.toFilePath());
      await f.writeAsBytes(zipData);
      return null; // Success
    }
    
    return 'Export cancelled.';
  }
}
