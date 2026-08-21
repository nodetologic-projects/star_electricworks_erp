import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

final outstandingSummaryProvider = FutureProvider<List<OutstandingSummaryRow>>((ref) {
  final repo = ref.watch(invoicesRepositoryProvider);
  return repo.getOutstandingSummary();
});

final customerLedgerProvider = FutureProvider.family<CustomerLedgerResult, int>((ref, customerId) {
  final repo = ref.watch(invoicesRepositoryProvider);
  return repo.getCustomerLedger(customerId);
});
