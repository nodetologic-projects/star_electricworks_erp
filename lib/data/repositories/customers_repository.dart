import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';

final customersRepositoryProvider = Provider((ref) {
  return CustomersRepository(ref.watch(databaseProvider));
});

class CustomersRepository {
  final AppDatabase _db;
  CustomersRepository(this._db);

  Future<List<Customer>> getAllCustomers() => (_db.select(_db.customers)..where((t) => t.isActive.equals(true))).get();
  
  Stream<List<Customer>> watchAllCustomers() => (_db.select(_db.customers)..where((t) => t.isActive.equals(true))).watch();
  Stream<List<Customer>> watchAllActiveAndInactive() => _db.select(_db.customers).watch();

  Future<Customer> getCustomerById(int id) {
    return (_db.select(_db.customers)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertCustomer(CustomersCompanion customer) {
    return _db.into(_db.customers).insert(customer);
  }

  Future<bool> updateCustomer(CustomersCompanion customer) {
    return _db.update(_db.customers).replace(customer);
  }

  Future<int> deleteCustomer(int id) {
    return (_db.delete(_db.customers)..where((t) => t.id.equals(id))).go();
  }
}
