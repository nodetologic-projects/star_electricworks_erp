import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:starelectricerp/features/quotations/providers/quotations_providers.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/quotations/pdf/quotation_pdf.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/core/services/direct_print_service.dart';

class QuotationDetailScreen extends ConsumerWidget {
  final int quotationId;

  const QuotationDetailScreen({super.key, required this.quotationId});

  StatusBadgeType _getStatusBadge(QuotationStatus status) {
    switch (status) {
      case QuotationStatus.draft: return StatusBadgeType.pending;
      case QuotationStatus.sent: return StatusBadgeType.pending;
      case QuotationStatus.accepted: return StatusBadgeType.paid;
      case QuotationStatus.rejected: return StatusBadgeType.overdue;
      case QuotationStatus.expired: return StatusBadgeType.overdue;
      case QuotationStatus.converted: return StatusBadgeType.paid;
    }
  }

  Future<void> _updateStatus(BuildContext context, WidgetRef ref, QuotationStatus status) async {
    final repo = ref.read(quotationsRepositoryProvider);
    await repo.updateStatus(quotationId, status);
    ref.invalidate(quotationDetailProvider(quotationId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(quotationDetailProvider(quotationId));

    return AppLayout(
      currentRoute: '/quotations',
      appBar: AppBar(
        title: const Text('Quotation Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      child: detailAsync.when(
        data: (data) {
          final q = data.quotation;
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    StatusBadge(type: _getStatusBadge(q.status)),
                    const SizedBox(width: 16),
                    Text('Total: ₹${q.estimatedAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    if (data.company != null) ...[
                      ElevatedButton.icon(
                        onPressed: () => DirectPrintService.printPdf(
                          context, 
                          q.quoteNo, 
                          fallbackGenerate: () => QuotationPdfGenerator.generate(
                            company: data.company!,
                            data: data,
                          )
                        ),
                        icon: const Icon(Icons.print),
                        label: const Text('Direct Print'),
                      ),
                      const SizedBox(width: 8),
                    ],

                    
                    if (q.status == QuotationStatus.draft) ...[
                      OutlinedButton.icon(
                        onPressed: () => context.push('/quotations/${q.id}/edit'),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Quote'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () => _updateStatus(context, ref, QuotationStatus.sent),
                        icon: const Icon(Icons.send),
                        label: const Text('Mark Sent'),
                      ),
                    ],
                    
                    if (q.status == QuotationStatus.sent) ...[
                      OutlinedButton.icon(
                        onPressed: () => _updateStatus(context, ref, QuotationStatus.rejected),
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('Mark Rejected', style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () => _updateStatus(context, ref, QuotationStatus.accepted),
                        icon: const Icon(Icons.check),
                        label: const Text('Mark Accepted'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],

                    if (q.status == QuotationStatus.accepted)
                      FilledButton.icon(
                        onPressed: () {
                          // Convert to Invoice
                          context.push('/invoices/new', extra: {
                            'type': InvoiceType.serviceTaxInvoice,
                            'customerId': data.customer?.id,
                            'jobId': data.motorJob?.id,
                            'sourceQuotationId': q.id,
                            'amount': q.estimatedAmount,
                            'description': q.description,
                          });
                        },
                        icon: const Icon(Icons.transform),
                        label: const Text('Convert to Invoice'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade700),
                      ),
                      
                    if (q.status == QuotationStatus.converted)
                      OutlinedButton.icon(
                        onPressed: () {
                          if (q.convertedInvoiceId != null) {
                            context.push('/invoices/${q.convertedInvoiceId}');
                          }
                        },
                        icon: const Icon(Icons.receipt),
                        label: const Text('View Invoice'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: data.company == null
                  ? const Center(child: Text('Please update company settings first.'))
                  : PdfPreview(
                      build: (format) => QuotationPdfGenerator.generate(
                        company: data.company!,
                        data: data,
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
