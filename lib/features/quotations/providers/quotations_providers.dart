import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';

final quotationsListProvider = FutureProvider.autoDispose<List<QuotationWithCustomer>>((ref) {
  final repo = ref.watch(quotationsRepositoryProvider);
  return repo.getQuotations();
});

final quotationDetailProvider = FutureProvider.autoDispose.family<QuotationWithCustomer, int>((ref, id) {
  final repo = ref.watch(quotationsRepositoryProvider);
  return repo.getQuotationById(id);
});
