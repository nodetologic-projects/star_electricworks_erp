import 'dart:io';
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
import 'package:drift/drift.dart' as drift;

import 'package:starelectricerp/data/repositories/cashbook_repository.dart';
import 'package:starelectricerp/data/repositories/purchases_repository.dart';

class PurchasesListScreen extends ConsumerWidget {
  const PurchasesListScreen({super.key});

  Future<void> _confirmDeletePurchase(BuildContext context, WidgetRef ref, Purchase p) async {
    final db = ref.read(databaseProvider);
    
    // Check for linked cashbook entries heuristically
    final cashRepo = ref.read(cashbookRepositoryProvider);
    final linkedCashbookEntries = await (db.select(db.cashTransactions)..where((t) => 
      t.transactionDate.equals(p.purchaseDate) & 
      t.amount.equals(p.totalAmount) & 
      t.category.equals('Purchase') &
      t.description.equals('Purchase from ${p.vendorName}')
    )).get();

    bool deleteCashbookAlso = false;

    if (context.mounted) {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Delete Purchase?'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Delete this purchase record? This cannot be undone.'),
                    if (linkedCashbookEntries.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('This purchase seems to have a linked Cash Book entry.', style: TextStyle(fontWeight: FontWeight.bold)),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Also delete linked Cash Book entry'),
                        value: deleteCashbookAlso,
                        onChanged: (val) => setState(() => deleteCashbookAlso = val ?? false),
                      )
                    ]
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('DELETE'),
                  ),
                ],
              );
            },
          );
        }
      );

      if (res == true && context.mounted) {
        await ref.read(purchasesRepositoryProvider).deletePurchase(p.id);
        
        if (deleteCashbookAlso && linkedCashbookEntries.isNotEmpty) {
          for (final c in linkedCashbookEntries) {
            await cashRepo.deleteTransaction(c.id);
          }
        }
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase deleted.')));
        }
      }
    }
  }

  Future<void> _exportToExcel(BuildContext context, List<Purchase> purchases, DateTimeRange? dateRange) async {
    final dateFormat = DateFormat('dd MMM yyyy');
    final List<List<dynamic>> rows = [
      ['Date', 'Vendor Name', 'Total Amount', 'Payment Mode', 'Notes', 'Has Attachment']
    ];

    for (final p in purchases) {
      rows.add([
        dateFormat.format(p.purchaseDate),
        p.vendorName,
        p.totalAmount,
        p.paymentMode?.name.toUpperCase() ?? '',
        p.notes ?? '',
        p.billImagePath != null ? 'Yes' : 'No',
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

  void _showImageDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ),
            Image.file(File(path), fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(filteredPurchasesProvider);
    final dateRange = ref.watch(purchasesDateRangeProvider);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2, locale: 'en_IN');
    final dateFormat = DateFormat('dd MMM yyyy');

    double totalAmount = 0;
    if (purchasesAsync.hasValue) {
      totalAmount = purchasesAsync.value!.fold(0, (sum, p) => sum + p.totalAmount);
    }

    return AppLayout(
      currentRoute: '/purchases',
      appBar: AppBar(title: const Text('Purchases')),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                Text(
                  'Business Purchases',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
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
                      'Total Amount',
                      'Payment',
                      'Attachment',
                      'Actions'
                    ],
                    data: purchases,
                    searchHint: 'Search by vendor name...',
                    emptyMessage: 'No purchases found for the selected period.',
                    onSearchChanged: (val) {
                      ref.read(purchasesSearchQueryProvider.notifier).setQuery(val);
                    },
                    buildRow: (p) {
                      return [
                        Text(dateFormat.format(p.purchaseDate)),
                        Text(p.vendorName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(currencyFormat.format(p.totalAmount), style: const TextStyle().mono),
                        Text(p.paymentMode?.name.toUpperCase() ?? ''),
                        p.billImagePath != null 
                            ? InkWell(
                                onTap: () => _showImageDialog(context, p.billImagePath!),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: FileImage(File(p.billImagePath!)),
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                ),
                              )
                            : const Text('-'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              tooltip: 'Edit Purchase',
                              onPressed: () => context.push('/purchases/edit/${p.id}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              tooltip: 'Delete Purchase',
                              onPressed: () => _confirmDeletePurchase(context, ref, p),
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
