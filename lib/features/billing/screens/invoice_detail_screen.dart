import 'dart:typed_data';

import 'package:starelectricerp/core/services/direct_print_service.dart';

import 'package:starelectricerp/core/utils/permission_util.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';
import 'package:starelectricerp/features/billing/providers/invoice_detail_provider.dart';
import 'package:starelectricerp/features/settings/dsc_signer.dart';
import 'package:starelectricerp/features/billing/screens/record_payment_dialog.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:intl/intl.dart';

const _invoiceCopyTypes = ['Original for Recipient', 'Duplicate for Transporter', 'Triplicate for Supplier'];

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  final int invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  String _selectedCopyType = 'Original for Recipient';

  String? _getSignedSinglePdfPath(String? baseSignedPath, String copyType) {
    if (baseSignedPath == null || baseSignedPath.isEmpty) return null;
    if (baseSignedPath.endsWith('_signed_all.pdf')) {
      return baseSignedPath.replaceAll('_signed_all.pdf', '_signed_${copyType.replaceAll(' ', '_')}.pdf');
    }
    if (baseSignedPath.endsWith('_draft_all.pdf')) { // Mac fallback
      return baseSignedPath.replaceAll('_draft_all.pdf', '_draft_${copyType.replaceAll(' ', '_')}.pdf');
    }
    return baseSignedPath; // Fallback for old invoices
  }

  Future<void> _downloadPdf(BuildContext context, InvoiceDetailData data) async {
    try {
      Uint8List bytes;
      final singlePath = _getSignedSinglePdfPath(data.invoice.signedPdfPath, _selectedCopyType);
      if (singlePath != null && await File(singlePath).exists()) {
        bytes = await File(singlePath).readAsBytes();
      } else if (data.invoice.signedPdfPath != null && data.invoice.signedPdfPath!.isNotEmpty) {
        bytes = await File(data.invoice.signedPdfPath!).readAsBytes();
      } else {
        bytes = await InvoicePdfGenerator.generate(
          copyLabels: [_selectedCopyType],
          company: data.companySetting,
          invoice: data.invoice,
          items: data.items,
          customer: data.customer,
          originalInvoice: data.originalInvoice,
          totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
        );
      }


      final hasPermission = await PermissionUtil.requestStoragePermission();
      if (!hasPermission) throw Exception('Storage permission denied');

      final docsDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docsDir.path}/Star Electric Works Invoices');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('${dir.path}/${data.invoice.invoiceNo}.pdf');
      
      await file.writeAsBytes(bytes);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save PDF: $e')),
        );
      }
    }
  }

  Future<String?> _promptForPin(BuildContext context) async {
    String pin = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Token PIN'),
        content: TextField(
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'PIN'),
          onChanged: (val) => pin = val,
          onSubmitted: (_) => Navigator.pop(context, pin),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, pin),
            child: const Text('Sign'),
          ),
        ],
      ),
    );
  }


Future<void> _signAndPrint(BuildContext context, InvoiceDetailData data) async {
    print("ACTION: Sign & Print button pressed");
    
    // If already signed, just print
    if (data.invoice.signedPdfPath != null && data.invoice.signedPdfPath!.isNotEmpty) {
      print("INFO: Invoice already signed (path: ${data.invoice.signedPdfPath}), skipping to print step");
      await _executePrintStep(context, data, explicitPdfPath: data.invoice.signedPdfPath);
      return;
    }

    print("ACTION: Starting Sign step...");
    final resultPath = await _signAndFinalize(context, data);
    print("RESULT: Sign step returned path=$resultPath");
    
    if (resultPath != null) {
      print("ACTION: Starting Print step...");
      if (context.mounted) {
        await _executePrintStep(context, data, explicitPdfPath: resultPath);
      } else {
        print("ERROR: Cannot execute print step - context is no longer mounted after signing");
      }
    } else {
      print("INFO: Skipping Print step because Sign step failed or was cancelled");
    }
  }

  Future<void> _executePrintStep(BuildContext context, InvoiceDetailData data, {String? explicitPdfPath}) async {
    try {
      print("ACTION: Calling DirectPrintService.printPdf with explicitPdfPath=$explicitPdfPath");
      await DirectPrintService.printPdf(
        context,
        data.invoice.invoiceNo,
        explicitPdfPath: explicitPdfPath,
        fallbackGenerate: () => InvoicePdfGenerator.generate(
          copyLabels: [_selectedCopyType],
          company: data.companySetting,
          invoice: data.invoice,
          items: data.items,
          customer: data.customer,
          totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
        )
      );
      print("RESULT: Print step completed (check DirectPrintService logs for success/failure)");
    } catch (e, stack) {
      print("ERROR: Print step threw an exception: $e\n$stack");
    }
  }

  Future<String?> _signAndFinalize(BuildContext context, InvoiceDetailData data) async {
    try {
      final method = data.companySetting.dscSigningMethod ?? DscSigningMethod.fileBased;
      
      String? passwordOrPin;
      String? certOrDllPath;
      
      if (method == DscSigningMethod.usbToken) {
        certOrDllPath = data.companySetting.dscPkcs11DllPath;
        if (certOrDllPath == null || certOrDllPath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PKCS#11 DLL Driver Path not set in Settings!')),
          );
          return null;
        }
        
        passwordOrPin = await _promptForPin(context);
        if (passwordOrPin == null || passwordOrPin.isEmpty) {
          return null; // Cancelled
        }
      } else {
        certOrDllPath = data.companySetting.dscCertPath;
        if (certOrDllPath == null || certOrDllPath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('DSC Certificate path not set in Settings!')),
          );
          return null;
        }

        const storage = FlutterSecureStorage();
        passwordOrPin = await storage.read(key: 'dsc_password');
        if (passwordOrPin == null || passwordOrPin.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('DSC Password not set in Settings!')),
            );
          }
          return null;
        }
      }

      final hasPermission = await PermissionUtil.requestStoragePermission();
      if (!hasPermission) throw Exception('Storage permission denied');

      final docsDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docsDir.path}/Star Electric Works Invoices');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Generate base PDFs for batch signing
      List<String> inputPaths = [];
      List<String> outputPaths = [];

      // Generate all 3 copies in one PDF
      final bytesAll = await InvoicePdfGenerator.generate(
        copyLabels: _invoiceCopyTypes,
        company: data.companySetting,
        invoice: data.invoice,
        items: data.items,
        customer: data.customer,
        totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
      );
      final draftAll = File('${dir.path}/${data.invoice.invoiceNo}_draft_all.pdf');
      final signedAll = File('${dir.path}/${data.invoice.invoiceNo}_signed_all.pdf');
      await draftAll.writeAsBytes(bytesAll);
      inputPaths.add(draftAll.path);
      outputPaths.add(signedAll.path);

      // Generate individual PDFs for the dropdown/save
      for (final label in _invoiceCopyTypes) {
        final bytesSingle = await InvoicePdfGenerator.generate(
          copyLabels: [label],
          company: data.companySetting,
          invoice: data.invoice,
          items: data.items,
          customer: data.customer,
          totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
        );
        final labelSafe = label.replaceAll(' ', '_');
        final draftSingle = File('${dir.path}/${data.invoice.invoiceNo}_draft_${labelSafe}.pdf');
        final signedSingle = File('${dir.path}/${data.invoice.invoiceNo}_signed_${labelSafe}.pdf');
        await draftSingle.writeAsBytes(bytesSingle);
        inputPaths.add(draftSingle.path);
        outputPaths.add(signedSingle.path);
      }

      final inputPdfPath = inputPaths.join('|');
      final outputPdfPath = outputPaths.join('|');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing PDF via ${method == DscSigningMethod.usbToken ? "USB Token" : "File"}...')),
        );
      }

      final error = method == DscSigningMethod.usbToken 
        ? await DscSigner.signPdfToken(
            inputPdfPath: inputPdfPath,
            outputPdfPath: outputPdfPath,
            dllPath: certOrDllPath,
            pin: passwordOrPin,
          )
        : await DscSigner.signPdf(
            inputPdfPath: inputPdfPath,
            outputPdfPath: outputPdfPath,
            certPath: certOrDllPath,
            password: passwordOrPin,
          );

      passwordOrPin = '';

      if (!context.mounted) return null;

      print("RESULT of DscSigner (null means success): $error");
      
      if (error == null) {
        final repo = ref.read(invoicesRepositoryProvider);
        await repo.updateInvoiceStatus(data.invoice.id, InvoiceStatus.sent);
        await repo.updateSignedPdfPath(data.invoice.id, signedAll.path);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed successfully! Saved to: ${signedAll.path}')),
          );
        }
        ref.invalidate(invoiceDetailProvider(widget.invoiceId));
        return signedAll.path;
      } else if (error == 'UnsupportedPlatform') {
        final repo = ref.read(invoicesRepositoryProvider);
        await repo.updateInvoiceStatus(data.invoice.id, InvoiceStatus.sent);
        await repo.updateSignedPdfPath(data.invoice.id, draftAll.path); // Fallback for Mac
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signing is only supported on Windows. Invoice finalized without signature.')),
          );
        }
        ref.invalidate(invoiceDetailProvider(widget.invoiceId));
        return draftAll.path;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signing failed: $error'),
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during signing: $e')),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(invoiceDetailProvider(widget.invoiceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice View'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/invoices'),
        ),
      ),
      body: detailAsync.when(
        data: (data) {
            return Column(
              children: [
                if (data.invoice.requiresEWayBill && !data.invoice.invoiceType.isCreditNote)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    color: Colors.amber.shade100,
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.amber.shade900),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This invoice may require an e-Way Bill (goods value ≥ ₹50,000).',
                            style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('e-Way Bill generation API not yet configured.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber.shade900,
                            side: BorderSide(color: Colors.amber.shade900),
                          ),
                          child: const Text('Generate e-Way Bill'),
                        ),
                      ],
                    ),
                  ),
                if (data.invoice.invoiceType.isNote)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    color: Colors.blueGrey.shade50,
                    child: Row(
                      children: [
                        Icon(Icons.link, color: Colors.blueGrey.shade800),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Against Invoice: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  if (data.originalInvoice != null)
                                    InkWell(
                                      onTap: () => context.push('/invoices/${data.originalInvoice!.id}'),
                                      child: Text(
                                        '${data.originalInvoice!.invoiceNo} (dated ${DateFormat('dd/MM/yyyy').format(data.originalInvoice!.invoiceDate)})',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(data.invoice.originalInvoiceId != null ? 'Invoice #${data.invoice.originalInvoiceId}' : 'N/A'),
                                ],
                              ),
                              if (data.invoice.noteReason != null)
                                Text(
                                  'Reason: ${data.invoice.noteReason!.displayName}${data.invoice.noteReasonText != null && data.invoice.noteReasonText!.isNotEmpty ? ' - ${data.invoice.noteReasonText}' : ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          StatusBadge(
                            type: data.invoice.status == InvoiceStatus.draft || data.invoice.status == InvoiceStatus.sent
                                ? StatusBadgeType.pending
                                : data.invoice.status == InvoiceStatus.partiallyPaid
                                    ? StatusBadgeType.partiallyPaid
                                    : data.invoice.status == InvoiceStatus.paid
                                        ? StatusBadgeType.paid
                                        : data.invoice.status == InvoiceStatus.overdue
                                            ? StatusBadgeType.overdue
                                            : StatusBadgeType.dispatched,
                          ),
                          const SizedBox(width: 16),
                          if (data.invoice.invoiceType.isCreditNote)
                            Text('Credit Total: ₹${data.invoice.grandTotal.toStringAsFixed(2)}', 
                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
                          else ...[
                            Text('Total: ₹${data.invoice.grandTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(width: 16),
                            Text('Balance Due: ₹${data.balanceDue.toStringAsFixed(2)}', 
                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                          ],
                          if (data.invoice.status == InvoiceStatus.draft)
                            ElevatedButton.icon(
                              onPressed: () => context.push('/invoices/edit/${data.invoice.id}'),
                              icon: const Icon(Icons.edit),
                              label: Text(data.invoice.invoiceType.isNote ? 'Edit Note' : 'Edit Invoice'),
                            )
                          else
                            Tooltip(
                              message: data.invoice.invoiceType.isNote
                                  ? "Finalized notes cannot be edited."
                                  : "Finalized invoices can't be edited — create a credit note or new invoice for corrections instead.",
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.edit),
                                label: Text(data.invoice.invoiceType.isNote ? 'Edit Note' : 'Edit Invoice'),
                              ),
                            ),
                          if (!data.invoice.invoiceType.isNote &&
                              data.invoice.status != InvoiceStatus.draft &&
                              (data.invoice.invoiceType == InvoiceType.serviceTaxInvoice ||
                               data.invoice.invoiceType == InvoiceType.salesTaxInvoice ||
                               data.invoice.invoiceType == InvoiceType.billOfSupply)) ...[
                            FilledButton.icon(
                              onPressed: () => context.push(
                                '/invoices/new',
                                extra: {
                                  'type': InvoiceType.credit_note,
                                  'customerId': data.invoice.customerId,
                                  'originalInvoiceId': data.invoice.id,
                                },
                              ),
                              icon: const Icon(Icons.remove_circle_outline, size: 18),
                              label: const Text('Create Credit Note'),
                              style: FilledButton.styleFrom(backgroundColor: Colors.orange.shade800),
                            ),
                            FilledButton.icon(
                              onPressed: () => context.push(
                                '/invoices/new',
                                extra: {
                                  'type': InvoiceType.debit_note,
                                  'customerId': data.invoice.customerId,
                                  'originalInvoiceId': data.invoice.id,
                                },
                              ),
                              icon: const Icon(Icons.add_circle_outline, size: 18),
                              label: const Text('Create Debit Note'),
                              style: FilledButton.styleFrom(backgroundColor: Colors.teal.shade800),
                            ),
                          ],
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _selectedCopyType,
                            items: _invoiceCopyTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCopyType = val);
                            },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => DirectPrintService.printPdf(
                              context, 
                              data.invoice.invoiceNo, 
                              explicitPdfPath: _getSignedSinglePdfPath(data.invoice.signedPdfPath, _selectedCopyType) ?? data.invoice.signedPdfPath,
                              fallbackGenerate: () => InvoicePdfGenerator.generate(
                                copyLabels: [_selectedCopyType],
                                company: data.companySetting,
                                invoice: data.invoice,
                                items: data.items,
                                customer: data.customer,
                                originalInvoice: data.originalInvoice,
                                totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
                              )
                            ),
                            icon: const Icon(Icons.print),
                            label: const Text('Direct Print'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => DirectPrintService.printPdf(
                              context, 
                              data.invoice.invoiceNo, 
                              explicitPdfPath: data.invoice.signedPdfPath,
                              fallbackGenerate: () => InvoicePdfGenerator.generate(
                                copyLabels: _invoiceCopyTypes,
                                company: data.companySetting,
                                invoice: data.invoice,
                                items: data.items,
                                customer: data.customer,
                                originalInvoice: data.originalInvoice,
                                totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
                              )
                            ),
                            icon: const Icon(Icons.print_rounded),
                            label: const Text('Print All 3 Copies'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _downloadPdf(context, data),
                            icon: const Icon(Icons.download),
                            label: const Text('Save PDF'),
                          ),

                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: () => _signAndPrint(context, data),
                            icon: const Icon(Icons.print_rounded),
                            label: const Text('Sign & Print'),
                            style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade700),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: () => _signAndFinalize(context, data),

                            icon: const Icon(Icons.verified),
                            label: const Text('Sign'),
                            style: FilledButton.styleFrom(backgroundColor: Colors.green.shade700),
                          ),
                          if (!data.invoice.invoiceType.isCreditNote) ...[
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                                final res = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => RecordPaymentDialog(invoice: data.invoice, balanceDue: data.balanceDue),
                                );
                                if (res == true) {
                                  ref.invalidate(invoiceDetailProvider(widget.invoiceId));
                                }
                              },
                              icon: const Icon(Icons.payment),
                              label: const Text('Record Payment'),
                            ),
                          ],
                        ],
                      ),
                      if (data.creditNotes.isNotEmpty || data.debitNotes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.receipt_long, size: 20, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            Text(
                              'Linked Notes (${data.creditNotes.length} Credit, ${data.debitNotes.length} Debit)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              'Net Adjustment: ₹${(data.totalDebitNotes - data.totalCreditNotes).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (data.totalDebitNotes - data.totalCreditNotes) >= 0 ? Colors.teal.shade800 : Colors.orange.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...data.creditNotes.map((cn) => ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.remove_circle, color: Colors.orange),
                          title: Text('Credit Note ${cn.invoiceNo} - ₹${cn.grandTotal.toStringAsFixed(2)}'),
                          subtitle: Text('Date: ${DateFormat('dd/MM/yyyy').format(cn.invoiceDate)} | Reason: ${cn.noteReason?.displayName ?? "Sales Return"}${cn.noteReasonText != null ? " (${cn.noteReasonText})" : ""}'),
                          trailing: const Icon(Icons.chevron_right, size: 18),
                          onTap: () => context.push('/invoices/${cn.id}'),
                        )),
                        ...data.debitNotes.map((dn) => ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.add_circle, color: Colors.teal),
                          title: Text('Debit Note ${dn.invoiceNo} - ₹${dn.grandTotal.toStringAsFixed(2)}'),
                          subtitle: Text('Date: ${DateFormat('dd/MM/yyyy').format(dn.invoiceDate)} | Reason: ${dn.noteReason?.displayName ?? "Additional Charges"}${dn.noteReasonText != null ? " (${dn.noteReasonText})" : ""}'),
                          trailing: const Icon(Icons.chevron_right, size: 18),
                          onTap: () => context.push('/invoices/${dn.id}'),
                        )),
                      ],
                      if (data.payments.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        ...data.payments.map((p) => ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text('₹${p.amount.toStringAsFixed(2)} via ${p.paymentMode.name.toUpperCase()}'),
                          subtitle: Text('${DateFormat('dd/MM/yyyy').format(p.paymentDate)} ${p.referenceNo != null ? " | Ref: ${p.referenceNo}" : ""}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            tooltip: 'Edit Payment',
                            onPressed: () async {
                              final totalPaidExcludingThis = data.payments
                                  .where((item) => item.id != p.id)
                                  .fold<double>(0, (s, x) => s + x.amount);
                              final balanceDue = (data.invoice.grandTotal + data.totalDebitNotes - data.totalCreditNotes - totalPaidExcludingThis).clamp(0.0, double.infinity);
                              final updated = await showDialog<bool>(
                                context: context,
                                builder: (_) => RecordPaymentDialog(
                                  invoice: data.invoice,
                                  balanceDue: balanceDue,
                                  existingPayment: p,
                                ),
                              );
                              if (updated == true) {
                                ref.invalidate(invoiceDetailProvider(widget.invoiceId));
                              }
                            },
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: PdfPreview(
                  key: ValueKey('${data.invoice.signedPdfPath ?? 'unsigned'}_${_selectedCopyType}'),
                  build: (format) async {
                    final singlePath = _getSignedSinglePdfPath(data.invoice.signedPdfPath, _selectedCopyType);
                    if (singlePath != null && await File(singlePath).exists()) {
                      return await File(singlePath).readAsBytes();
                    }
                    if (data.invoice.signedPdfPath != null && data.invoice.signedPdfPath!.isNotEmpty) {
                      final file = File(data.invoice.signedPdfPath!);
                      if (await file.exists()) {
                        return await file.readAsBytes();
                      }
                    }
                    return await InvoicePdfGenerator.generate(
                      copyLabels: [_selectedCopyType],
                      company: data.companySetting,
                      invoice: data.invoice,
                      items: data.items,
                      customer: data.customer,
                      originalInvoice: data.originalInvoice,
                      totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
                    );
                  },
                  allowPrinting: true,
                  allowSharing: true,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  initialPageFormat: PdfPageFormat.a4,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
