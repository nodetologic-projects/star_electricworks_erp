import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';

final quotationsListProvider = FutureProvider<List<QuotationWithCustomer>>((ref) {
  final repo = ref.watch(quotationsRepositoryProvider);
  return repo.getQuotations();
});

final quotationDetailProvider = FutureProvider.family<QuotationWithCustomer, int>((ref, id) {
  final repo = ref.watch(quotationsRepositoryProvider);
  return repo.getQuotationById(id);
});
