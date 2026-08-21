import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/financial_year.dart';

final invoicesRepositoryProvider = Provider((ref) {
  return InvoicesRepository(ref.watch(databaseProvider));
});

class InvoicesRepository {
  final AppDatabase _db;
  InvoicesRepository(this._db);

  Future<List<Invoice>> getAllInvoices() => _db.select(_db.invoices).get();
  
  Stream<List<Invoice>> watchAllInvoices() => _db.select(_db.invoices).watch();

  Stream<List<Invoice>> watchFilteredInvoices({String query = '', InvoiceType? type}) {
    final statement = _db.select(_db.invoices);
    
    if (query.isNotEmpty) {
      statement.where((t) => t.invoiceNo.like('%$query%'));
    }
    if (type != null) {
      statement.where((t) => t.invoiceType.equals(type.name));
    }
    
    statement.orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    return statement.watch();
  }

  Future<Invoice> getInvoiceById(int id) {
    return (_db.select(_db.invoices)..where((t) => t.id.equals(id))).getSingle();
  }

  String _getPrefixForType(InvoiceType type) {
    switch (type) {
      case InvoiceType.serviceTaxInvoice:
      case InvoiceType.salesTaxInvoice:
        return 'INV';
      case InvoiceType.billOfSupply:
        return 'BOS';
      case InvoiceType.purchaseVoucher:
        return 'PUR';
      case InvoiceType.deliveryChallan:
        return 'DC';
    }
  }

  Future<Invoice?> findDuplicateInvoice({
    required int customerId,
    required InvoiceType type,
    required double grandTotal,
    required DateTime date,
  }) async {
    final cutoff = date.subtract(const Duration(hours: 24));
    final query = _db.select(_db.invoices)
      ..where((t) => t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBetweenValues(cutoff, date))
      ..orderBy([(t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc)])
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<int> createInvoiceWithItems(InvoicesCompanion invoice, List<InvoiceItemsCompanion> items) {
    return _db.transaction(() async {
      // 1. Generate Invoice Number atomically
      final typeEnum = invoice.invoiceType.value;
      final prefix = _getPrefixForType(typeEnum);
      
      final date = invoice.invoiceDate.value;
      // We must import FinancialYear at the top of this file
      final label = FinancialYear.getLabelForDate(date);
      
      // Query sequence
      final seqQuery = _db.select(_db.financialYearSequence)
        ..where((t) => t.invoiceTypePrefix.equals(prefix) & t.financialYearLabel.equals(label));
      final currentSeq = await seqQuery.getSingleOrNull();
      
      int nextNumber = 1;
      if (currentSeq != null) {
        nextNumber = currentSeq.lastNumber + 1;
        await (_db.update(_db.financialYearSequence)..where((t) => t.id.equals(currentSeq.id)))
            .write(FinancialYearSequenceCompanion(lastNumber: Value(nextNumber)));
      } else {
        await _db.into(_db.financialYearSequence).insert(
          FinancialYearSequenceCompanion.insert(
            invoiceTypePrefix: prefix,
            financialYearLabel: label,
            lastNumber: Value(nextNumber),
          )
        );
      }
      
      final newInvoiceNo = '$prefix-${FinancialYear.getRolloverLabel(label, nextNumber)}';
      
      final finalInvoice = invoice.copyWith(invoiceNo: Value(newInvoiceNo));
      final invoiceId = await _db.into(_db.invoices).insert(finalInvoice);
      
      for (var item in items) {
        await _db.into(_db.invoiceItems).insert(item.copyWith(invoiceId: Value(invoiceId)));
        
        // Handle Stock Movements if this item is from CopperStock
        if (item.itemSourceType.value == ItemSourceType.copperStock && item.copperStockId.present && item.copperStockId.value != null) {
          final stockId = item.copperStockId.value!;
          final qty = item.qty.value ?? 0.0;
          
          if (qty > 0) {
            MovementType movementType;
            final invoiceType = invoice.invoiceType.value;
            
            if (invoiceType == InvoiceType.purchaseVoucher) {
              movementType = MovementType.purchaseIn;
            } else {
              movementType = MovementType.saleOut;
            }
            
            // Record Movement
            await _db.into(_db.stockMovements).insert(
              StockMovementsCompanion.insert(
                copperStockId: stockId,
                movementType: movementType,
                weightKg: qty,
                referenceInvoiceId: Value(invoiceId),
                notes: Value('Invoice ${invoice.invoiceNo.value}'),
              )
            );
            
            // Update CopperStock qty
            final currentStock = await (_db.select(_db.copperStock)..where((t) => t.id.equals(stockId))).getSingle();
            double newQty = currentStock.stockQtyKg;
            if (movementType == MovementType.purchaseIn) {
              newQty += qty;
            } else {
              newQty -= qty;
            }
            
            await (_db.update(_db.copperStock)..where((t) => t.id.equals(stockId)))
                .write(CopperStockCompanion(stockQtyKg: Value(newQty)));
          }
        }
      }
      
      return invoiceId;
    });
  }

  Future<List<InvoiceItem>> getItemsForInvoice(int invoiceId) {
    return (_db.select(_db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId))).get();
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final totalSalesQuery = _db.select(_db.invoices)
      ..where((t) => t.invoiceDate.isBetweenValues(startOfMonth, endOfMonth) &
                     t.status.isIn([InvoiceStatus.sent.name, InvoiceStatus.paid.name]));
    final monthInvoices = await totalSalesQuery.get();
    
    double totalSales = 0.0;
    double gstCollected = 0.0;
    for (var inv in monthInvoices) {
      totalSales += inv.grandTotal;
      gstCollected += inv.cgstAmount + inv.sgstAmount;
    }

    final pendingQuery = _db.select(_db.invoices)
      ..where((t) => t.status.isIn([InvoiceStatus.draft.name, InvoiceStatus.sent.name]));
    final pendingInvoices = await pendingQuery.get();
    
    int pendingCount = pendingInvoices.length;
    double pendingAmount = 0.0;
    for (var inv in pendingInvoices) {
      pendingAmount += inv.grandTotal;
    }

    return {
      'totalSales': totalSales,
      'gstCollected': gstCollected,
      'pendingCount': pendingCount,
      'pendingAmount': pendingAmount,
    };
  }

  Future<List<InvoiceWithCustomer>> getRecentInvoices(int limit) async {
    final query = _db.select(_db.invoices).join([
      innerJoin(_db.customers, _db.customers.id.equalsExp(_db.invoices.customerId)),
    ])
      ..orderBy([OrderingTerm(expression: _db.invoices.invoiceDate, mode: OrderingMode.desc)])
      ..limit(limit);

    final rows = await query.get();
    return rows.map((row) {
      return InvoiceWithCustomer(
        invoice: row.readTable(_db.invoices),
        customer: row.readTable(_db.customers),
      );
    }).toList();
  }

  Future<List<InvoiceWithCustomer>> getInvoicesByDateRange(DateTime start, DateTime end) async {
    final endInclusive = DateTime(end.year, end.month, end.day, 23, 59, 59);
    final query = _db.select(_db.invoices).join([
      innerJoin(_db.customers, _db.customers.id.equalsExp(_db.invoices.customerId)),
    ])
      ..where(_db.invoices.invoiceDate.isBetweenValues(start, endInclusive))
      ..orderBy([OrderingTerm(expression: _db.invoices.invoiceDate, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return rows.map((row) {
      return InvoiceWithCustomer(
        invoice: row.readTable(_db.invoices),
        customer: row.readTable(_db.customers),
      );
    }).toList();
  }

  Future<List<GstSummaryRow>> getGstSummaryByMonth() async {
    // We fetch all non-draft/cancelled invoices and group them in dart to avoid complex sqlite date formatting
    final query = _db.select(_db.invoices)
      ..where((t) => t.status.isIn([InvoiceStatus.sent.name, InvoiceStatus.paid.name, InvoiceStatus.delivered.name, InvoiceStatus.overdue.name]))
      ..orderBy([(t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.asc)]);

    final invoices = await query.get();
    
    final Map<String, GstSummaryRow> grouped = {};
    for (var inv in invoices) {
      final monthStr = '${inv.invoiceDate.year}-${inv.invoiceDate.month.toString().padLeft(2, '0')}';
      if (!grouped.containsKey(monthStr)) {
        grouped[monthStr] = GstSummaryRow(month: monthStr, totalSales: 0, cgst: 0, sgst: 0, igst: 0);
      }
      final current = grouped[monthStr]!;
      grouped[monthStr] = GstSummaryRow(
        month: current.month,
        totalSales: current.totalSales + inv.grandTotal,
        cgst: current.cgst + inv.cgstAmount,
        sgst: current.sgst + inv.sgstAmount,
        igst: current.igst,
      );
    }
    
    return grouped.values.toList().reversed.toList(); // Newest first
  }
  
  Future<int> updateInvoiceStatus(int id, InvoiceStatus status) {
    return (_db.update(_db.invoices)..where((t) => t.id.equals(id))).write(
      InvoicesCompanion(status: Value(status)),
    );
  }
  Future<List<Payment>> getPaymentsForInvoice(int invoiceId) {
    return (_db.select(_db.payments)..where((t) => t.invoiceId.equals(invoiceId))
      ..orderBy([(t) => OrderingTerm(expression: t.paymentDate, mode: OrderingMode.desc)])
    ).get();
  }

  Future<int> addPayment(PaymentsCompanion payment) {
    return _db.transaction(() async {
      // 1. Insert the payment
      final paymentId = await _db.into(_db.payments).insert(payment);
      
      final invoiceId = payment.invoiceId.value;
      
      // 2. Compute total payments
      final allPayments = await getPaymentsForInvoice(invoiceId);
      final totalPaid = allPayments.fold<double>(0.0, (sum, p) => sum + p.amount);
      
      // 3. Fetch invoice grand total
      final invoice = await getInvoiceById(invoiceId);
      
      // 4. Determine new status
      InvoiceStatus newStatus = invoice.status;
      if (totalPaid >= invoice.grandTotal) {
        newStatus = InvoiceStatus.paid;
      } else if (totalPaid > 0) {
        newStatus = InvoiceStatus.partiallyPaid;
      } else {
        // If 0, and somehow was paid before, we might revert to sent. 
        // But usually this only goes forward.
        if (invoice.status == InvoiceStatus.paid || invoice.status == InvoiceStatus.partiallyPaid) {
           newStatus = InvoiceStatus.sent;
        }
      }
      
      // 5. Update invoice status
      if (newStatus != invoice.status) {
        await updateInvoiceStatus(invoiceId, newStatus);
      }
      
      return paymentId;
    });
  }

  Future<void> markReminderSent(int invoiceId) async {
    await (_db.update(_db.invoices)..where((t) => t.id.equals(invoiceId))).write(
      InvoicesCompanion(reminderSentDate: Value(DateTime.now())),
    );
  }

  Future<List<OutstandingSummaryRow>> getOutstandingSummary() async {
    // We fetch all non-draft/cancelled invoices and group them in dart to avoid complex sqlite date formatting
    final query = _db.select(_db.invoices).join([
      innerJoin(_db.customers, _db.customers.id.equalsExp(_db.invoices.customerId)),
    ])
      ..where(_db.invoices.status.isIn([InvoiceStatus.sent.name, InvoiceStatus.partiallyPaid.name, InvoiceStatus.overdue.name, InvoiceStatus.delivered.name]));

    final rows = await query.get();
    
    // We need payments for these invoices
    final activeInvoiceIds = rows.map((r) => r.readTable(_db.invoices).id).toSet();
    final allPayments = await (_db.select(_db.payments)..where((t) => t.invoiceId.isIn(activeInvoiceIds))).get();
    
    final Map<int, OutstandingSummaryRow> summary = {};
    
    for (var row in rows) {
      final invoice = row.readTable(_db.invoices);
      final customer = row.readTable(_db.customers);
      
      final invoicePayments = allPayments.where((p) => p.invoiceId == invoice.id).fold<double>(0.0, (s, p) => s + p.amount);
      final balanceDue = invoice.grandTotal - invoicePayments;
      
      if (balanceDue <= 0) continue; // Actually fully paid but status not updated? Safeguard.
      
      if (!summary.containsKey(customer.id)) {
        summary[customer.id] = OutstandingSummaryRow(
          customer: customer,
          openInvoicesCount: 0,
          totalOutstanding: 0.0,
          oldestOverdueDate: null,
        );
      }
      
      final current = summary[customer.id]!;
      DateTime? oldest = current.oldestOverdueDate;
      if (invoice.status == InvoiceStatus.overdue) {
        if (oldest == null || invoice.invoiceDate.isBefore(oldest)) {
          oldest = invoice.invoiceDate;
        }
      }
      
      summary[customer.id] = OutstandingSummaryRow(
        customer: customer,
        openInvoicesCount: current.openInvoicesCount + 1,
        totalOutstanding: current.totalOutstanding + balanceDue,
        oldestOverdueDate: oldest,
      );
    }
    
    final sorted = summary.values.toList()
      ..sort((a, b) => b.totalOutstanding.compareTo(a.totalOutstanding));
    return sorted;
  }

  Future<CustomerLedgerResult> getCustomerLedger(int customerId) async {
    final query = _db.select(_db.invoices)..where((t) => t.customerId.equals(customerId))
      ..orderBy([(t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc)]);
      
    final invoices = await query.get();
    
    final invoiceIds = invoices.map((i) => i.id).toSet();
    final allPayments = invoiceIds.isEmpty ? <Payment>[] : await (_db.select(_db.payments)..where((t) => t.invoiceId.isIn(invoiceIds))).get();
    
    double totalBilled = 0.0;
    double totalPaid = 0.0;
    List<LedgerInvoiceRow> ledgerRows = [];
    
    for (var inv in invoices) {
      // Exclude draft from totals? Usually yes, drafts aren't billed yet. But let's just include all non-draft for billed.
      if (inv.status != InvoiceStatus.draft) {
        totalBilled += inv.grandTotal;
      }
      
      final paymentsForInv = allPayments.where((p) => p.invoiceId == inv.id).fold<double>(0.0, (s, p) => s + p.amount);
      totalPaid += paymentsForInv;
      
      ledgerRows.add(LedgerInvoiceRow(
        invoice: inv,
        totalPaid: paymentsForInv,
        balanceDue: inv.grandTotal - paymentsForInv,
      ));
    }
    
    return CustomerLedgerResult(
      totalBilled: totalBilled,
      totalPaid: totalPaid,
      totalOutstanding: totalBilled - totalPaid,
      invoices: ledgerRows,
    );
  }

  Future<List<Invoice>> getInvoicesByJobId(int jobId) async {
    final query = _db.select(_db.invoiceItems)..where((tbl) => tbl.motorJobId.equals(jobId));
    final items = await query.get();
    if (items.isEmpty) return [];
    
    final invoiceIds = items.map((i) => i.invoiceId).toSet();
    return (_db.select(_db.invoices)..where((tbl) => tbl.id.isIn(invoiceIds))).get();
  }
}

class OutstandingSummaryRow {
  final Customer customer;
  final int openInvoicesCount;
  final double totalOutstanding;
  final DateTime? oldestOverdueDate;

  OutstandingSummaryRow({
    required this.customer,
    required this.openInvoicesCount,
    required this.totalOutstanding,
    this.oldestOverdueDate,
  });
}

class LedgerInvoiceRow {
  final Invoice invoice;
  final double totalPaid;
  final double balanceDue;

  LedgerInvoiceRow({
    required this.invoice,
    required this.totalPaid,
    required this.balanceDue,
  });
}

class CustomerLedgerResult {
  final double totalBilled;
  final double totalPaid;
  final double totalOutstanding;
  final List<LedgerInvoiceRow> invoices;

  CustomerLedgerResult({
    required this.totalBilled,
    required this.totalPaid,
    required this.totalOutstanding,
    required this.invoices,
  });
}






class InvoiceWithCustomer {
  final Invoice invoice;
  final Customer customer;
  InvoiceWithCustomer({required this.invoice, required this.customer});
}

class GstSummaryRow {
  final String month;
  final double totalSales;
  final double cgst;
  final double sgst;
  final double igst;

  GstSummaryRow({
    required this.month,
    required this.totalSales,
    required this.cgst,
    required this.sgst,
    required this.igst,
  });


}
