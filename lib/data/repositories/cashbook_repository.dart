import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

final cashbookRepositoryProvider = Provider((ref) {
  return CashbookRepository(ref.watch(databaseProvider));
});

class CashbookRepository {
  final AppDatabase _db;

  CashbookRepository(this._db);

  // Categories
  Future<List<CashCategory>> getCategories() {
    return (_db.select(_db.cashCategories)..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
  }

  Future<int> addCategory(String name) {
    return _db.into(_db.cashCategories).insert(CashCategoriesCompanion.insert(name: name));
  }

  // Transactions
  Future<int> addTransaction(CashTransactionsCompanion transaction) {
    return _db.into(_db.cashTransactions).insert(transaction);
  }

  Future<bool> updateTransaction(CashTransactionsCompanion transaction) async {
    return await _db.update(_db.cashTransactions).replace(transaction);
  }

  Future<bool> deleteTransaction(int id) async {
    return await (_db.delete(_db.cashTransactions)..where((t) => t.id.equals(id))).go() > 0;
  }

  Future<List<CashTransaction>> getTransactions({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) {
    final query = _db.select(_db.cashTransactions)
      ..where((t) {
        var expr = t.transactionDate.isBetweenValues(startDate, endDate);
        if (category != null && category.isNotEmpty && category != 'All') {
          expr = expr & t.category.equals(category);
        }
        return expr;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    return query.get();
  }

  Future<Map<String, double>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    final transactions = await getTransactions(startDate: startDate, endDate: endDate, category: category);

    double totalIncome = 0;
    double totalExpense = 0;

    for (final t in transactions) {
      if (t.transactionType == CashTransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netBalance': totalIncome - totalExpense,
    };
  }

  Future<void> deleteCashTransaction(int id) async {
    await (_db.delete(_db.cashTransactions)..where((t) => t.id.equals(id))).go();
  }
}
