import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';

final customersStreamProvider = StreamProvider<List<Customer>>((ref) {
  final repo = ref.watch(customersRepositoryProvider);
  return repo.watchAllCustomers();
});
