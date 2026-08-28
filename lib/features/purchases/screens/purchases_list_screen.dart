import 'package:flutter/material.dart' as flutter_material;
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/features/purchases/providers/purchases_provider.dart';
import 'package:starelectricerp/features/reports/utils/excel_export.dart';
import 'package:starelectricerp/data/database.dart';

class PurchasesListScreen extends ConsumerWidget {
  const PurchasesListScreen({super.key});

  Future<void> _exportToExcel(BuildContext context, List<Purchase> purchases, DateTimeRange? dateRange) async {
    final dateFormat = DateFormat('dd MMM yyyy');
    final List<List<dynamic>> rows = [
      ['Date', 'Vendor Name', 'Category', 'Description', 'Amount', 'GST Amount', 'Payment Mode', 'Notes']
    ];

    for (final p in purchases) {
      rows.add([
        dateFormat.format(p.purchaseDate),
        p.vendorName,
        p.category,
        p.description,
        p.amount,
        p.gstAmount ?? '',
        p.paymentMode?.name.toUpperCase() ?? '',
        p.notes ?? '',
      ]);
    }

    final dateStr = dateRange != null ? '${DateFormat('yyyyMMdd').format(dateRange.start)}_${DateFormat('yyyyMMdd').format(dateRange.end)}' : 'All';
    final path = await ExcelExport.exportData('Purchases_$dateStr', rows);
    
    if (context.mounted) {
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to: $path')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export cancelled.')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(filteredPurchasesProvider);
    final dateRange = ref.watch(purchasesDateRangeProvider);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2, locale: 'en_IN');
    final dateFormat = DateFormat('dd MMM yyyy');

    double totalAmount = 0;
    if (purchasesAsync.hasValue) {
      totalAmount = purchasesAsync.value!.fold(0, (sum, p) => sum + p.amount);
    }

    return AppLayout(
      currentRoute: '/purchases',
      appBar: AppBar(title: const Text('Purchases')),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Business Purchases',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Wrap(
                  spacing: 16,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(dateRange != null 
                        ? '${dateFormat.format(dateRange.start)} - ${dateFormat.format(dateRange.end)}'
                        : 'Select Date Range'),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                          initialDateRange: dateRange != null 
                            ? flutter_material.DateTimeRange(start: dateRange.start, end: dateRange.end)
                            : null,
                        );
                        if (picked != null) {
                          ref.read(purchasesDateRangeProvider.notifier).setDateRange( DateTimeRange(start: picked.start, end: picked.end));
                        }
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Export Excel'),
                      onPressed: () {
                        if (purchasesAsync.hasValue) {
                          _exportToExcel(context, purchasesAsync.value!, dateRange);
                        }
                      },
                    ),
                    AppButton(
                      label: '+ Add Purchase',
                      onPressed: () => context.push('/purchases/new'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryMaroon.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Total for Period: ${currencyFormat.format(totalAmount)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryMaroon,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: purchasesAsync.when(
                data: (purchases) {
                  return AppDataTable(
                    columns: const [
                      'Date',
                      'Vendor',
                      'Category',
                      'Description',
                      'Amount',
                    ],
                    data: purchases,
                    searchHint: 'Search by vendor, category, or description...',
                    emptyMessage: 'No purchases found for the selected period.',
                    onSearchChanged: (val) {
                      ref.read(purchasesSearchQueryProvider.notifier).setQuery(val);
                    },
                    buildRow: (p) {
                      return [
                        Text(dateFormat.format(p.purchaseDate)),
                        Text(p.vendorName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(p.category, style: const TextStyle(fontSize: 12)),
                        ),
                        Text(p.description),
                        Text(currencyFormat.format(p.amount), style: const TextStyle().mono),
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
