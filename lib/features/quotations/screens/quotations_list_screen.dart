import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/quotations/providers/quotations_providers.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';

class QuotationSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String val) => state = val;
}

final quotationSearchQueryProvider = NotifierProvider<QuotationSearchQuery, String>(QuotationSearchQuery.new);

final filteredQuotationsListProvider = Provider<AsyncValue<List<QuotationWithCustomer>>>((ref) {
  final query = ref.watch(quotationSearchQueryProvider).toLowerCase();
  final asyncData = ref.watch(quotationsListProvider);

  return asyncData.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((item) {
      final name = item.customer?.name ?? item.quotation.prospectiveCustomerName ?? '';
      return name.toLowerCase().contains(query) || item.quotation.quoteNo.toLowerCase().contains(query);
    }).toList();
  });
});

class QuotationsListScreen extends ConsumerWidget {
  const QuotationsListScreen({super.key});

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

  
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, QuotationWithCustomer q) async {
    String typedText = '';
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Quotation?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete Quotation #${q.quotation.id}? This will permanently remove it.'),
            const SizedBox(height: 16),
            const Text('Type "DELETE" below to confirm:'),
            TextField(
              autofocus: true,
              onChanged: (val) => typedText = val,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (typedText.trim() == 'DELETE') {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('CONFIRM DELETE'),
          ),
        ],
      ),
    );
    if (res == true && context.mounted) {
      await ref.read(quotationsRepositoryProvider).deleteQuotation(q.quotation.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quotation #${q.quotation.id} deleted.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(filteredQuotationsListProvider);

    return AppLayout(
      currentRoute: '/quotations',
      appBar: AppBar(title: const Text('Quotations')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/quotations/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Quotation'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: listAsync.when(
                data: (list) {
                  return AppDataTable<QuotationWithCustomer>(
                    columns: const [
                      'Quote No',
                      'Customer',
                      'Date',
                      'Valid Until',
                      'Amount (₹)',
                      'Status',
                      'Actions',
                    ],
                    data: list,
                    searchHint: 'Search by quote no or customer...',
                    emptyMessage: 'No quotations found.',
                    onSearchChanged: (val) => ref.read(quotationSearchQueryProvider.notifier).setQuery(val),
                    buildRow: (item) {
                      final q = item.quotation;
                      final custName = item.customer?.name ?? q.prospectiveCustomerName ?? 'Unknown';
                      
                      return [
                        Text(q.quoteNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(custName),
                        Text(DateFormat('dd/MM/yyyy').format(q.createdAt)),
                        Text(q.validUntil != null ? DateFormat('dd/MM/yyyy').format(q.validUntil!) : 'N/A'),
                        Text(q.estimatedAmount.toStringAsFixed(2)),
                        StatusBadge(type: _getStatusBadge(q.status)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => context.push('/quotations/${q.id}'),
                              icon: const Icon(Icons.remove_red_eye, size: 16),
                              label: const Text('View'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _confirmDelete(context, ref, item),
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
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
