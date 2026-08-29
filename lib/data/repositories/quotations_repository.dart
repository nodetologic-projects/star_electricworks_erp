import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:drift/drift.dart';

final quotationsRepositoryProvider = Provider((ref) => QuotationsRepository(ref.watch(databaseProvider)));

class QuotationWithCustomer {
  final Quotation quotation;
  final Customer? customer;
  final MotorJob? motorJob;
  final CompanySetting? company;

  QuotationWithCustomer({
    required this.quotation,
    this.customer,
    this.motorJob,
    this.company,
  });
}

class QuotationsRepository {
  final AppDatabase _db;

  QuotationsRepository(this._db);

  Future<List<QuotationWithCustomer>> getQuotations() async {
    print('REPO: getQuotations started');
    final query = _db.select(_db.quotations).join([
      leftOuterJoin(_db.customers, _db.customers.id.equalsExp(_db.quotations.customerId)),
      leftOuterJoin(_db.motorJobs, _db.motorJobs.id.equalsExp(_db.quotations.motorJobId)),
    ])..orderBy([OrderingTerm(expression: _db.quotations.createdAt, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return rows.map((row) {
      return QuotationWithCustomer(
        quotation: row.readTable(_db.quotations),
        customer: row.readTableOrNull(_db.customers),
        motorJob: row.readTableOrNull(_db.motorJobs),
      );
    }).toList();
  }

  Future<QuotationWithCustomer> getQuotationById(int id) async {
    final query = _db.select(_db.quotations).join([
      leftOuterJoin(_db.customers, _db.customers.id.equalsExp(_db.quotations.customerId)),
      leftOuterJoin(_db.motorJobs, _db.motorJobs.id.equalsExp(_db.quotations.motorJobId)),
    ])..where(_db.quotations.id.equals(id));

    final row = await query.getSingle();
    final companyResult = await _db.select(_db.companySettings).getSingleOrNull();

    return QuotationWithCustomer(
      quotation: row.readTable(_db.quotations),
      customer: row.readTableOrNull(_db.customers),
      motorJob: row.readTableOrNull(_db.motorJobs),
      company: companyResult,
    );
  }

  Future<int> insertQuotation(QuotationsCompanion quotation) async {
    return _db.transaction(() async {
      // Find latest quote id for numbering
      final maxIdResult = await (_db.select(_db.quotations)
        ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
        ..limit(1)
      ).getSingleOrNull();

      final nextId = (maxIdResult?.id ?? 0) + 1;
      final formattedNo = 'QUO-${nextId.toString().padLeft(4, '0')}';
      
      final companionToInsert = quotation.copyWith(
        quoteNo: Value(formattedNo),
        status: const Value(QuotationStatus.draft),
      );

      return _db.into(_db.quotations).insert(companionToInsert);
    });
  }

  Future<void> updateQuotation(int id, QuotationsCompanion quotation) async {
    await (_db.update(_db.quotations)..where((t) => t.id.equals(id))).write(quotation);
  }

  Future<void> updateStatus(int id, QuotationStatus status) async {
    await updateQuotation(id, QuotationsCompanion(status: Value(status)));
  }

  Future<void> markConverted(int quotationId, int invoiceId) async {
    await updateQuotation(quotationId, QuotationsCompanion(
      status: const Value(QuotationStatus.converted),
      convertedInvoiceId: Value(invoiceId),
    ));
  }

  Future<void> deleteQuotation(int id) async {
    return _db.transaction(() async {
      final q = await getQuotationById(id);
      
      await _db.into(_db.deletedRecordsLog).insert(
        DeletedRecordsLogCompanion.insert(
          entityType: 'Quotation',
          entityId: id,
          deletedAt: DateTime.now().toIso8601String(),
          snapshot: q.quotation.toJsonString(),
        )
      );

      await (_db.delete(_db.quotations)..where((t) => t.id.equals(id))).go();
    });
  }
}
