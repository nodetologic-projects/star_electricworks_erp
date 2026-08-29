import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/purchases_repository.dart';

class DateTimeRange {
  final DateTime start;
  final DateTime end;
  const DateTimeRange({required this.start, required this.end});
}

class PurchasesDateRange extends Notifier<DateTimeRange?> {
  @override
  DateTimeRange? build() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999),
    );
  }
  void setDateRange(DateTimeRange? range) => state = range;
}

final purchasesDateRangeProvider = NotifierProvider<PurchasesDateRange, DateTimeRange?>(PurchasesDateRange.new);

class PurchasesSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}

final purchasesSearchQueryProvider = NotifierProvider<PurchasesSearchQuery, String>(PurchasesSearchQuery.new);

final purchasesStreamProvider = StreamProvider<List<Purchase>>((ref) {
  final repo = ref.watch(purchasesRepositoryProvider);
  final dateRange = ref.watch(purchasesDateRangeProvider);
  
  if (dateRange == null) {
    return Stream.value([]);
  }

  final adjustedEnd = DateTime(
    dateRange.end.year,
    dateRange.end.month,
    dateRange.end.day,
    23, 59, 59, 999
  );

  return repo.watchPurchases(dateRange.start, adjustedEnd);
});

final filteredPurchasesProvider = Provider<AsyncValue<List<Purchase>>>((ref) {
  final purchases = ref.watch(purchasesStreamProvider);
  final query = ref.watch(purchasesSearchQueryProvider).toLowerCase();

  return purchases.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((p) {
      return p.vendorName.toLowerCase().contains(query) ||
             (p.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});
