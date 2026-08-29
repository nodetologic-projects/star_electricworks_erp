import 'dart:typed_data';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

class CAExportService {
  final InvoicesRepository repo;
  
  CAExportService(this.repo);

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
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return 'No invoices found for the selected period.';
    }

    // 2. Prepare zip
    final archive = Archive();
    int addedCount = 0;
    
    for (var invoice in filtered) {
      
      final pdfPath = invoice.signedPdfPath;
      if (pdfPath != null && File(pdfPath).existsSync()) {
        final fileBytes = await File(pdfPath).readAsBytes();
        final fileName = '${invoice.invoiceNo.replaceAll('/', '_')}.pdf';
        final archiveFile = ArchiveFile(fileName, fileBytes.length, fileBytes);
        archive.addFile(archiveFile);
        addedCount++;
      }
    }
    
    if (addedCount == 0) {
      return 'No generated PDF files found for the selected invoices.';
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
