import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

class DashboardData {
  final Map<String, dynamic> stats;
  final List<InvoiceWithCustomer> recentInvoices;
  final List<CopperStockData> lowStockItems;

  DashboardData({
    required this.stats,
    required this.recentInvoices,
    required this.lowStockItems,
  });
}

final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final invoicesRepo = ref.watch(invoicesRepositoryProvider);
  final stockRepo = ref.watch(copperStockRepositoryProvider);

  final stats = await invoicesRepo.getDashboardStats();
  final recentInvoices = await invoicesRepo.getRecentInvoices(5);
  final lowStockItems = await stockRepo.getLowStockItems();

  return DashboardData(
    stats: stats,
    recentInvoices: recentInvoices,
    lowStockItems: lowStockItems,
  );
});
