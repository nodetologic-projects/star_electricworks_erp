import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

final copperStockRepositoryProvider = Provider((ref) {
  return CopperStockRepository(ref.watch(databaseProvider));
});

class CopperStockRepository {
  final AppDatabase _db;
  CopperStockRepository(this._db);

  Future<List<CopperStockData>> getAllCopperStock() => _db.select(_db.copperStock).get();
  
  Stream<List<CopperStockData>> watchAllCopperStock() => _db.select(_db.copperStock).watch();

  Stream<List<CopperStockData>> watchFilteredCopperStock({String query = ''}) {
    final statement = _db.select(_db.copperStock)..where((t) => t.isActive.equals(true));
    
    if (query.isNotEmpty) {
      statement.where((t) => t.description.like('%$query%'));
    }
    
    statement.orderBy([(t) => drift.OrderingTerm(expression: t.id, mode: drift.OrderingMode.asc)]);
    return statement.watch();
  }

  Future<CopperStockData> getCopperStockById(int id) {
    return (_db.select(_db.copperStock)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertCopperStock(CopperStockCompanion stock) {
    return _db.into(_db.copperStock).insert(stock);
  }

  Future<bool> updateCopperStock(CopperStockCompanion stock) {
    return _db.update(_db.copperStock).replace(stock);
  }

  Future<int> deleteCopperStock(int id) {
    return (_db.delete(_db.copperStock)..where((t) => t.id.equals(id))).go();
  }

  Future<void> adjustStock(int stockId, double weightKg, MovementType type, {String? notes}) async {
    await _db.transaction(() async {
      // 1. Get current stock
      final currentStock = await getCopperStockById(stockId);
      
      // 2. Calculate new weight
      double newWeight = currentStock.stockQtyKg;
      if (type == MovementType.purchaseIn || type == MovementType.adjustment && weightKg > 0) {
        newWeight += weightKg;
      } else if (type == MovementType.saleOut || type == MovementType.adjustment && weightKg < 0) {
        newWeight -= weightKg.abs();
      }

      // 3. Update CopperStock
      await (_db.update(_db.copperStock)..where((t) => t.id.equals(stockId)))
          .write(CopperStockCompanion(stockQtyKg: drift.Value(newWeight)));
      
      // 4. Record StockMovement
      await _db.into(_db.stockMovements).insert(
        StockMovementsCompanion.insert(
          copperStockId: stockId,
          movementType: type,
          weightKg: weightKg,
          notes: notes != null && notes.isNotEmpty ? drift.Value(notes) : const drift.Value.absent(),
        )
      );
    });
  }

  Future<List<CopperStockData>> getLowStockItems() async {
    final query = _db.select(_db.copperStock)
      ..where((t) => t.reorderLevelKg.isNotNull() & t.stockQtyKg.isSmallerOrEqual(t.reorderLevelKg));
    return query.get();
  }

  Future<void> safeDeleteCopperStock(int id) async {
    await _db.transaction(() async {
      final movements = await (_db.select(_db.stockMovements)..where((t) => t.copperStockId.equals(id))).get();
      
      if (movements.isEmpty) {
        // Safe to hard delete if no movements exist
        await deleteCopperStock(id);
      } else {
        // Soft delete if movements exist
        await (_db.update(_db.copperStock)..where((t) => t.id.equals(id)))
            .write(const CopperStockCompanion(isActive: drift.Value(false)));
      }
    });
  }
}
