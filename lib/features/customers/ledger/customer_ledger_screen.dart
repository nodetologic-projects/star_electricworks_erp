import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/customers/providers/ledger_providers.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

class CustomerLedgerScreen extends ConsumerWidget {
  final int customerId;
  const CustomerLedgerScreen({super.key, required this.customerId});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(customerLedgerProvider(customerId));

    return AppLayout(
      currentRoute: '/ledger', // keep active sidebar item
      appBar: AppBar(
        title: const Text('Customer Ledger Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      child: ledgerAsync.when(
        data: (result) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    _buildSummaryCard(context, 'Lifetime Billed', result.totalBilled, Colors.blue.shade700),
                    const SizedBox(width: 16),
                    _buildSummaryCard(context, 'Total Paid', result.totalPaid, Colors.green.shade700),
                    const SizedBox(width: 16),
                    _buildSummaryCard(context, 'Total Outstanding', result.totalOutstanding, Colors.red.shade700),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Invoice History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: result.invoices.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final row = result.invoices[index];
                        final inv = row.invoice;
                        
                        return ListTile(
                          title: Row(
                            children: [
                              Text(inv.invoiceNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              StatusBadge(type: _getStatusBadge(inv.status)),
                            ],
                          ),
                          subtitle: Text(
                            'Date: ${DateFormat('dd/MM/yyyy').format(inv.invoiceDate)}\n'
                            'Grand Total: ₹${inv.grandTotal.toStringAsFixed(2)} | Paid: ₹${row.totalPaid.toStringAsFixed(2)} | Balance: ₹${row.balanceDue.toStringAsFixed(2)}'
                            '${inv.reminderSentDate != null ? "\nLast Reminder: ${DateFormat('dd/MM/yyyy HH:mm').format(inv.reminderSentDate!)}" : ""}'
                          ),
                          isThreeLine: true,
                          trailing: row.balanceDue > 0 ? OutlinedButton.icon(
                            icon: const Icon(Icons.notification_add, size: 16),
                            label: const Text('Send Reminder'),
                            onPressed: () async {
                              final repo = ref.read(invoicesRepositoryProvider);
                              await repo.markReminderSent(inv.id);
                              ref.invalidate(customerLedgerProvider(customerId));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reminder logged manually (Integration stub)')),
                                );
                              }
                            },
                          ) : null,
                          onTap: () {
                            context.push('/invoices/${inv.id}');
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color color) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.withValues(alpha: 0.3))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('₹${amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
