import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:drift/drift.dart';


final purchasesRepositoryProvider = Provider<PurchasesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PurchasesRepository(db);
});

class PurchasesRepository {
  final AppDatabase db;
  PurchasesRepository(this.db);

  Stream<List<Purchase>> watchPurchases(DateTime startDate, DateTime endDate) {
    return (db.select(db.purchases)
          ..where((t) => t.purchaseDate.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm(expression: t.purchaseDate, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> addPurchase(PurchasesCompanion entry) {
    return db.into(db.purchases).insert(entry);
  }

  Future<bool> updatePurchase(PurchasesCompanion entry) {
    return db.update(db.purchases).replace(entry);
  }

  Future<int> deletePurchase(int id) {
    return (db.delete(db.purchases)..where((t) => t.id.equals(id))).go();
  }
}
