import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/features/customers/providers/ledger_providers.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

class LedgerSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String val) => state = val;
}

final ledgerSearchQueryProvider = NotifierProvider<LedgerSearchQuery, String>(LedgerSearchQuery.new);

final filteredOutstandingSummaryProvider = Provider<AsyncValue<List<OutstandingSummaryRow>>>((ref) {
  final query = ref.watch(ledgerSearchQueryProvider).toLowerCase();
  final asyncData = ref.watch(outstandingSummaryProvider);

  return asyncData.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((item) => item.customer.name.toLowerCase().contains(query)).toList();
  });
});

class OutstandingSummaryScreen extends ConsumerWidget {
  const OutstandingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(filteredOutstandingSummaryProvider);

    return AppLayout(
      currentRoute: '/ledger',
      appBar: AppBar(title: const Text('Customer Ledger')),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer List',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: summaryAsync.when(
                data: (list) {
                  return AppDataTable<OutstandingSummaryRow>(
                    columns: const [
                      'Customer Name',
                      'Open Invoices',
                      'Total Outstanding (₹)',
                      'Oldest Overdue Date',
                      'Actions'
                    ],
                    data: list,
                    searchHint: 'Search by customer name...',
                    emptyMessage: 'No customers found.',
                    onSearchChanged: (val) {
                      ref.read(ledgerSearchQueryProvider.notifier).setQuery(val);
                    },
                    buildRow: (row) {
                      final oldestDate = row.oldestOverdueDate != null
                          ? DateFormat('dd/MM/yyyy').format(row.oldestOverdueDate!)
                          : 'None';
                      return [
                        Text(row.customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(row.openInvoicesCount.toString()),
                        Text(
                          row.totalOutstanding.toStringAsFixed(2),
                          style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                        ),
                        Text(oldestDate),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/customers/${row.customer.id}/ledger'),
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: const Text('View Ledger'),
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
