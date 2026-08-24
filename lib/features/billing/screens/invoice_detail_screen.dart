import 'package:starelectricerp/core/utils/permission_util.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class InvoiceDetailScreen extends ConsumerWidget {
  final int invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  Future<void> _downloadPdf(BuildContext context, InvoiceDetailData data) async {
    try {
      final bytes = await InvoicePdfGenerator.generate(
        company: data.companySetting,
        invoice: data.invoice,
        items: data.items,
        customer: data.customer,
      );


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

  Future<void> _signAndFinalize(BuildContext context, InvoiceDetailData data) async {
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
          return;
        }
        
        passwordOrPin = await _promptForPin(context);
        if (passwordOrPin == null || passwordOrPin.isEmpty) {
          return; // Cancelled
        }
      } else {
        certOrDllPath = data.companySetting.dscCertPath;
        if (certOrDllPath == null || certOrDllPath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('DSC Certificate path not set in Settings!')),
          );
          return;
        }

        const storage = FlutterSecureStorage();
        passwordOrPin = await storage.read(key: 'dsc_password');
        if (passwordOrPin == null || passwordOrPin.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('DSC Password not set in Settings!')),
            );
          }
          return;
        }
      }

      // Generate base PDF
      final bytes = await InvoicePdfGenerator.generate(
        company: data.companySetting,
        invoice: data.invoice,
        items: data.items,
        customer: data.customer,
      );


      final hasPermission = await PermissionUtil.requestStoragePermission();
      if (!hasPermission) throw Exception('Storage permission denied');

      final docsDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docsDir.path}/Star Electric Works Invoices');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final inputPdf = File('${dir.path}/${data.invoice.invoiceNo}_draft.pdf');
      final outputPdf = File('${dir.path}/${data.invoice.invoiceNo}_signed.pdf');
      
      await inputPdf.writeAsBytes(bytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing PDF via ${method == DscSigningMethod.usbToken ? "USB Token" : "File"}...')),
        );
      }

      final result = method == DscSigningMethod.usbToken 
        ? await DscSigner.signPdfToken(
            inputPdfPath: inputPdf.path,
            outputPdfPath: outputPdf.path,
            dllPath: certOrDllPath,
            pin: passwordOrPin,
          )
        : await DscSigner.signPdf(
            inputPdfPath: inputPdf.path,
            outputPdfPath: outputPdf.path,
            certPath: certOrDllPath,
            password: passwordOrPin,
          );

      passwordOrPin = '';

      if (!context.mounted) return;

      if (result == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed successfully! Saved to: ${outputPdf.path}')),
        );
      } else if (result == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signing is only supported on Windows. Proceeded with unsigned draft.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing failed with exit code: $result (Check hardware token or credentials)')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during signing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(invoiceDetailProvider(invoiceId));

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
                if (data.invoice.requiresEWayBill)
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
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
                          Text('Total: ₹${data.invoice.grandTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(width: 16),
                          Text('Balance Due: ₹${(data.invoice.grandTotal - data.payments.fold<double>(0, (s, p) => s + p.amount)).toStringAsFixed(2)}', 
                               style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () => _downloadPdf(context, data),
                            icon: const Icon(Icons.download),
                            label: const Text('Download PDF'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: () => _signAndFinalize(context, data),
                            icon: const Icon(Icons.verified),
                            label: const Text('Sign'),
                            style: FilledButton.styleFrom(backgroundColor: Colors.green.shade700),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: () async {
                              final balance = data.invoice.grandTotal - data.payments.fold<double>(0, (s, p) => s + p.amount);
                              final res = await showDialog<bool>(
                                context: context,
                                builder: (_) => RecordPaymentDialog(invoice: data.invoice, balanceDue: balance),
                              );
                              if (res == true) {
                                ref.invalidate(invoiceDetailProvider(invoiceId));
                              }
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text('Record Payment'),
                          ),
                        ],
                      ),
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
                        )),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: PdfPreview(
                  build: (format) => InvoicePdfGenerator.generate(
                    company: data.companySetting,
                    invoice: data.invoice,
                    items: data.items,
                    customer: data.customer,
                  ),
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
