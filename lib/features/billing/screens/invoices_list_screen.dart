import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/billing/providers/invoices_provider.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

class InvoicesListScreen extends ConsumerWidget {
  const InvoicesListScreen({super.key});

  String _formatType(InvoiceType type) {
    switch (type) {
      case InvoiceType.serviceTaxInvoice: return 'Service Tax Invoice';
      case InvoiceType.salesTaxInvoice: return 'Sales Tax Invoice';
      case InvoiceType.billOfSupply: return 'Bill of Supply';
      case InvoiceType.purchaseVoucher: return 'Purchase Voucher';
      case InvoiceType.deliveryChallan: return 'Delivery Challan';
      case InvoiceType.credit_note: return 'Credit Note';
      case InvoiceType.debit_note: return 'Debit Note';
    }
  }

  StatusBadgeType _getStatusBadge(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft: return StatusBadgeType.pending;
      case InvoiceStatus.sent: return StatusBadgeType.pending;
      case InvoiceStatus.partiallyPaid: return StatusBadgeType.partiallyPaid;
      case InvoiceStatus.paid: return StatusBadgeType.paid;
      case InvoiceStatus.overdue: return StatusBadgeType.overdue;
      case InvoiceStatus.delivered: return StatusBadgeType.dispatched;
    }
  }

  
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Invoice invoice) async {
    bool isDraft = invoice.status == InvoiceStatus.draft;
    
    if (isDraft) {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Draft Invoice?'),
          content: Text('Are you sure you want to delete ${invoice.invoiceNo}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('DELETE'),
            ),
          ],
        ),
      );
      if (res == true && context.mounted) {
        await ref.read(invoicesRepositoryProvider).deleteInvoice(invoice.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${invoice.invoiceNo} deleted.')));
      }
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cannot Delete Finalized Invoice'),
          content: const Text("Finalized invoices can't be edited or deleted — create a credit note or new entry for corrections instead."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);
    final currentFilter = ref.watch(invoiceFilterProvider);

    return AppLayout(
      currentRoute: '/invoices',
      appBar: AppBar(title: const Text('Invoices')),
      child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoices',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      AppButton(
                        label: '+ New Invoice',
                        onPressed: () => context.push('/invoices/new'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'all', label: Text('All')),
                          ButtonSegment(value: 'invoices', label: Text('Invoices')),
                          ButtonSegment(value: 'notes', label: Text('Notes (CN/DN)')),
                          ButtonSegment(value: 'challans', label: Text('Delivery Challans')),
                        ],
                        selected: {
                          if (currentFilter.notesOnly)
                            'notes'
                          else if (currentFilter.type == InvoiceType.deliveryChallan)
                            'challans'
                          else if (currentFilter.type == null)
                            'all'
                          else
                            'invoices'
                        },
                        onSelectionChanged: (selected) {
                          final val = selected.first;
                          if (val == 'all') {
                            ref.read(invoiceFilterProvider.notifier).updateType(null);
                          } else if (val == 'notes') {
                            ref.read(invoiceFilterProvider.notifier).updateNotesOnly(true);
                          } else if (val == 'challans') {
                            ref.read(invoiceFilterProvider.notifier).updateType(InvoiceType.deliveryChallan);
                          } else if (val == 'invoices') {
                            ref.read(invoiceFilterProvider.notifier).updateType(InvoiceType.serviceTaxInvoice);
                          }
                        },
                      ),
                      SizedBox(
                        width: 220,
                        child: AppSelect<InvoiceType?>(
                          label: 'Specific Type',
                          value: currentFilter.type,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Specific Types')),
                            ...InvoiceType.values.map((t) => DropdownMenuItem(value: t, child: Text(_formatType(t)))),
                          ],
                          onChanged: (val) {
                            ref.read(invoiceFilterProvider.notifier).updateType(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: invoicesAsync.when(
                      data: (invoices) {
                        return AppDataTable(
                          columns: const [
                            'Date',
                            'Invoice No',
                            'Type',
                            'Customer / Supplier',
                            'Total Amount',
                            'Status',
                            'Actions'
                          ],
                          data: invoices,
                          searchHint: 'Search by Invoice No...',
                          emptyMessage: 'No invoices found. Click "+ New Invoice" to get started.',
                          onSearchChanged: (val) {
                            ref.read(invoiceFilterProvider.notifier).updateQuery(val);
                          },
                          buildRow: (invoice) {
                            return [
                              Text(DateFormat('dd MMM yyyy').format(invoice.invoiceDate)),
                              Text(
                                invoice.invoiceNo,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(_formatType(invoice.invoiceType)),
                              Text('Customer #${invoice.customerId}'), // Will replace with joined query or provider
                              Text('₹${invoice.grandTotal.toStringAsFixed(2)}', style: const TextStyle().mono),
                              StatusBadge(type: _getStatusBadge(invoice.status)),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => context.push('/invoices/${invoice.id}'),
                                    icon: const Icon(Icons.visibility, size: 18),
                                    label: const Text('View'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _confirmDelete(context, ref, invoice),
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ];
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
