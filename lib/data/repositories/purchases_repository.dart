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

  Future<int> addPurchase(PurchasesCompanion entry, List<PurchaseItemsCompanion> items) async {
    return db.transaction(() async {
      final id = await db.into(db.purchases).insert(entry);
      for (final item in items) {
        await db.into(db.purchaseItems).insert(item.copyWith(purchaseId: Value(id)));
      }
      return id;
    });
  }

  Stream<List<PurchaseItem>> watchPurchaseItems(int purchaseId) {
    return (db.select(db.purchaseItems)..where((t) => t.purchaseId.equals(purchaseId))).watch();
  }

  Future<void> updatePurchase(PurchasesCompanion entry, List<PurchaseItemsCompanion> items) async {
    await db.transaction(() async {
      await db.update(db.purchases).replace(entry);
      // Delete old items and insert new ones
      await (db.delete(db.purchaseItems)..where((t) => t.purchaseId.equals(entry.id.value))).go();
      for (final item in items) {
        await db.into(db.purchaseItems).insert(item.copyWith(purchaseId: entry.id));
      }
    });
  }

  Future<int> deletePurchase(int id) async {
    return db.transaction(() async {
      await (db.delete(db.purchaseItems)..where((t) => t.purchaseId.equals(id))).go();
      return (db.delete(db.purchases)..where((t) => t.id.equals(id))).go();
    });
  }
}
