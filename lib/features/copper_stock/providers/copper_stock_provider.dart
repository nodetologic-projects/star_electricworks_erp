import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';

final copperStockStreamProvider = StreamProvider<List<CopperStockData>>((ref) {
  return ref.watch(copperStockRepositoryProvider).watchAllCopperStock();
});
class CopperStockSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final copperStockSearchQueryProvider = NotifierProvider<CopperStockSearchQuery, String>(CopperStockSearchQuery.new);

final filteredCopperStockProvider = StreamProvider<List<CopperStockData>>((ref) {
  final searchQuery = ref.watch(copperStockSearchQueryProvider);
  final repo = ref.watch(copperStockRepositoryProvider);
  
  return repo.watchFilteredCopperStock(query: searchQuery);
});
