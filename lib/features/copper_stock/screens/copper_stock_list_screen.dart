import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/copper_stock/providers/copper_stock_provider.dart';
import 'package:starelectricerp/features/copper_stock/screens/stock_adjustment_dialog.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

class CopperStockListScreen extends ConsumerWidget {
  const CopperStockListScreen({super.key});

  @override
  
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, CopperStockData stock) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Stock Item?'),
        content: Text('This will hide ${stock.description} from new selections but keep historical records intact.'),
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
      await ref.read(copperStockRepositoryProvider).safeDeleteCopperStock(stock.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${stock.description} deleted.')));
      // no need to refresh manually, riverpod will rebuild stream
    }
  }

    @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(filteredCopperStockProvider);

    return AppLayout(
      currentRoute: '/stock',
      appBar: AppBar(title: const Text('Copper Stock')),
      child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Copper Stock',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      AppButton(
                        label: '+ Add Stock Entry',
                        onPressed: () => context.push('/stock/new'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: stockAsync.when(
                      data: (stockList) {
                        return AppDataTable(
                          columns: const [
                            'Type',
                            'Description',
                            'Weight (kg)',
                            'Price/kg',
                            'GST %',
                            'Actions'
                          ],
                          data: stockList,
                          searchHint: 'Search by description...',
                          emptyMessage: 'No copper stock found. Click "+ Add Stock Entry" to get started.',
                          onSearchChanged: (val) {
                            ref.read(copperStockSearchQueryProvider.notifier).updateQuery(val);
                          },
                          buildRow: (stock) {
                            final isLowStock = stock.reorderLevelKg != null && 
                                               stock.stockQtyKg <= stock.reorderLevelKg!;
                            return [
                              StatusBadge(
                                type: stock.copperType == CopperType.newCopper 
                                  ? StatusBadgeType.newCopper 
                                  : StatusBadgeType.oldCopper
                              ),
                              Text(stock.description),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${stock.stockQtyKg.toStringAsFixed(2)} kg',
                                      style: TextStyle(
                                        fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
                                        color: isLowStock ? Colors.red.shade700 : null,
                                      ).mono,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isLowStock) ...[
                                    const SizedBox(width: 8),
                                    const StatusBadge(type: StatusBadgeType.lowStock),
                                  ]
                                ],
                              ),
                              Text('₹${stock.pricePerKg.toStringAsFixed(2)}', style: const TextStyle().mono),
                              Text(stock.gstRate != null ? '${stock.gstRate}%' : 'No GST', style: const TextStyle().mono),
                              Wrap(
                                spacing: 8,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => showDialog(
                                      context: context, 
                                      builder: (_) => StockAdjustmentDialog(stockId: stock.id)
                                    ),
                                    icon: const Icon(Icons.sync_alt, size: 18),
                                    label: const Text('Adjust'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => context.push('/stock/${stock.id}'),
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Edit'),
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
