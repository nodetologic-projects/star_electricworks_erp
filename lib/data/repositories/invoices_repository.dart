import 'package:drift/drift.dart' as import_drift;
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
    int? excludeInvoiceId,
  }) async {
    final cutoff = date.subtract(const Duration(hours: 24));
    final query = _db.select(_db.invoices)
      ..where((t) {
        var expr = t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBetweenValues(cutoff, date);
        if (excludeInvoiceId != null) {
          expr = expr & t.id.isNotValue(excludeInvoiceId);
        }
        return expr;
      })
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
      }
      
      String newInvoiceNo = '';
      bool isUnique = false;
      int attempts = 0;
      
      // Safeguard: Advance sequence if duplicate exists
      while (!isUnique && attempts < 10) {
        final rolloverLabel = FinancialYear.getRolloverLabel(label, nextNumber);
        final displayNum = ((nextNumber - 1) % 5000) + 1;
        newInvoiceNo = '$prefix-$rolloverLabel${displayNum.toString().padLeft(4, '0')}';
        
        final existing = await (_db.select(_db.invoices)..where((t) => t.invoiceNo.equals(newInvoiceNo))).getSingleOrNull();
        if (existing == null) {
          isUnique = true;
        } else {
          nextNumber++;
          attempts++;
        }
      }
      
      if (!isUnique) {
        throw Exception("Failed to generate a unique invoice number. Too many collisions.");
      }

      // Persist the safely incremented number
      if (currentSeq != null) {
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

  
  Future<void> updateInvoiceWithItems(int invoiceId, InvoicesCompanion invoiceCompanion, List<InvoiceItemsCompanion> newItems) {
    return _db.transaction(() async {
      final existingInvoice = await (_db.select(_db.invoices)..where((t) => t.id.equals(invoiceId))).getSingle();
      if (existingInvoice.status != InvoiceStatus.draft) {
        throw Exception("Only draft invoices can be edited.");
      }

      final existingItems = await (_db.select(_db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId))).get();
      
      for (var oldItem in existingItems) {
        if (oldItem.itemSourceType == ItemSourceType.copperStock && oldItem.copperStockId != null) {
          final stockId = oldItem.copperStockId!;
          final qty = oldItem.qty ?? 0.0;
          if (qty > 0) {
            MovementType movementType;
            if (existingInvoice.invoiceType == InvoiceType.purchaseVoucher) {
              movementType = MovementType.purchaseIn;
            } else {
              movementType = MovementType.saleOut;
            }

            final currentStock = await (_db.select(_db.copperStock)..where((t) => t.id.equals(stockId))).getSingleOrNull();
            if (currentStock != null) {
              double revertedQty = currentStock.stockQtyKg;
              if (movementType == MovementType.purchaseIn) {
                revertedQty -= qty; 
              } else {
                revertedQty += qty; 
              }
              await (_db.update(_db.copperStock)..where((t) => t.id.equals(stockId)))
                  .write(CopperStockCompanion(stockQtyKg: Value(revertedQty)));
            }

            await (_db.delete(_db.stockMovements)
                  ..where((t) => t.referenceInvoiceId.equals(invoiceId) & t.copperStockId.equals(stockId) & t.movementType.equals(movementType.name)))
                .go();
          }
        }
      }

      await (_db.delete(_db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId))).go();

      final updateCompanion = invoiceCompanion.copyWith(
        invoiceNo: const Value.absent(), 
        invoiceDate: const Value.absent(),
      );
      await (_db.update(_db.invoices)..where((t) => t.id.equals(invoiceId))).write(updateCompanion);

      for (var newItem in newItems) {
        await _db.into(_db.invoiceItems).insert(newItem.copyWith(invoiceId: Value(invoiceId)));
        
        if (newItem.itemSourceType.value == ItemSourceType.copperStock && newItem.copperStockId.present && newItem.copperStockId.value != null) {
          final stockId = newItem.copperStockId.value!;
          final qty = newItem.qty.value ?? 0.0;
          if (qty > 0) {
            MovementType movementType;
            final newInvoiceType = invoiceCompanion.invoiceType.present ? invoiceCompanion.invoiceType.value : existingInvoice.invoiceType;
            if (newInvoiceType == InvoiceType.purchaseVoucher) {
              movementType = MovementType.purchaseIn;
            } else {
              movementType = MovementType.saleOut;
            }
            
            await _db.into(_db.stockMovements).insert(
              StockMovementsCompanion.insert(
                copperStockId: stockId,
                movementType: movementType,
                weightKg: qty,
                referenceInvoiceId: Value(invoiceId),
                notes: Value('Invoice ${existingInvoice.invoiceNo} (Edited)'),
              )
            );
            
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
    });
  }

Future<List<InvoiceItem>> getItemsForInvoice(int invoiceId) {
    return (_db.select(_db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId))).get();
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    print('REPO: getDashboardStats started');
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final totalSalesQuery = _db.select(_db.invoices)
      ..where((t) => t.invoiceDate.isBetweenValues(startOfMonth, endOfMonth) &
                     t.status.isIn([InvoiceStatus.sent.name, InvoiceStatus.paid.name, InvoiceStatus.delivered.name, InvoiceStatus.partiallyPaid.name, InvoiceStatus.overdue.name]));
    final monthInvoices = await totalSalesQuery.get();
    
    double totalSales = 0.0;
    double gstCollected = 0.0;
    for (var inv in monthInvoices) {
      totalSales += inv.grandTotal;
      gstCollected += inv.cgstAmount + inv.sgstAmount + inv.igstAmount;
    }

    final pendingQuery = _db.select(_db.invoices)
      ..where((t) => t.status.isIn([InvoiceStatus.draft.name, InvoiceStatus.sent.name, InvoiceStatus.partiallyPaid.name, InvoiceStatus.overdue.name]));
    final pendingInvoices = await pendingQuery.get();
    
    int pendingCount = pendingInvoices.length;
    double pendingAmount = 0.0;
    for (var inv in pendingInvoices) {
      pendingAmount += inv.grandTotal;
    }

    print('REPO: getDashboardStats returning');
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

  Future<int> updateSignedPdfPath(int id, String path) {
    return (_db.update(_db.invoices)..where((t) => t.id.equals(id))).write(
      InvoicesCompanion(signedPdfPath: Value(path)),
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
    final customers = await (_db.select(_db.customers)..where((t) => t.isActive.equals(true))).get();
    final invoices = await (_db.select(_db.invoices)..where((t) => t.status.isNotIn([InvoiceStatus.draft.name]))).get();
    final payments = await _db.select(_db.payments).get();
    
    final Map<int, OutstandingSummaryRow> summary = {};
    
    for (var customer in customers) {
      summary[customer.id] = OutstandingSummaryRow(
        customer: customer,
        openInvoicesCount: 0,
        totalOutstanding: 0.0,
        oldestOverdueDate: null,
      );
    }

    for (var invoice in invoices) {
      if (!summary.containsKey(invoice.customerId)) continue;
      
      final invoicePayments = payments.where((p) => p.invoiceId == invoice.id).fold<double>(0.0, (s, p) => s + p.amount);
      final balanceDue = invoice.grandTotal - invoicePayments;
      
      final current = summary[invoice.customerId]!;
      
      int addedOpen = 0;
      double addedOut = 0.0;
      DateTime? oldest = current.oldestOverdueDate;
      
      if (balanceDue > 0) {
        addedOpen = 1;
        addedOut = balanceDue;
        if (invoice.status == InvoiceStatus.overdue || (invoice.dueDate != null && invoice.dueDate!.isBefore(DateTime.now()))) {
          if (oldest == null || invoice.invoiceDate.isBefore(oldest)) {
            oldest = invoice.invoiceDate;
          }
        }
      }
      
      summary[invoice.customerId] = OutstandingSummaryRow(
        customer: current.customer,
        openInvoicesCount: current.openInvoicesCount + addedOpen,
        totalOutstanding: current.totalOutstanding + addedOut,
        oldestOverdueDate: oldest,
      );
    }
    
    final sorted = summary.values.toList()
      ..sort((a, b) {
        if (a.totalOutstanding != b.totalOutstanding) {
          return b.totalOutstanding.compareTo(a.totalOutstanding);
        }
        return a.customer.name.compareTo(b.customer.name);
      });
    return sorted;
  }

  Future<CustomerLedgerResult> getCustomerLedger(int customerId) async {
    final customer = await (_db.select(_db.customers)..where((t) => t.id.equals(customerId))).getSingle();
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
      customer: customer,
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

  Future<void> deleteInvoice(int id) async {
    return _db.transaction(() async {
      final invoice = await getInvoiceById(id);
      
      if (invoice.status != InvoiceStatus.draft) {
        throw Exception("Only draft invoices can be deleted.");
      }
      
      final existingItems = await (_db.select(_db.invoiceItems)..where((t) => t.invoiceId.equals(id))).get();
      for (var oldItem in existingItems) {
        if (oldItem.itemSourceType == ItemSourceType.copperStock && oldItem.copperStockId != null) {
          final stockId = oldItem.copperStockId!;
          final qty = oldItem.qty ?? 0.0;
          if (qty > 0) {
            MovementType movementType;
            if (invoice.invoiceType == InvoiceType.purchaseVoucher) {
              movementType = MovementType.purchaseIn;
            } else {
              movementType = MovementType.saleOut;
            }

            final currentStock = await (_db.select(_db.copperStock)..where((t) => t.id.equals(stockId))).getSingleOrNull();
            if (currentStock != null) {
              double revertedQty = currentStock.stockQtyKg;
              if (movementType == MovementType.purchaseIn) {
                revertedQty -= qty; 
              } else {
                revertedQty += qty; 
              }
              await (_db.update(_db.copperStock)..where((t) => t.id.equals(stockId)))
                  .write(CopperStockCompanion(stockQtyKg: Value(revertedQty)));
            }

            await (_db.delete(_db.stockMovements)
                  ..where((t) => t.referenceInvoiceId.equals(id) & t.copperStockId.equals(stockId) & t.movementType.equals(movementType.name)))
                .go();
          }
        }
      }

      await _db.into(_db.deletedRecordsLog).insert(
        DeletedRecordsLogCompanion.insert(
          entityType: 'Invoice',
          entityId: id,
          deletedAt: DateTime.now().toIso8601String(),
          snapshot: invoice.toJsonString(),
        )
      );

      await (_db.delete(_db.invoiceItems)..where((t) => t.invoiceId.equals(id))).go();
      await (_db.delete(_db.payments)..where((t) => t.invoiceId.equals(id))).go();
      await (_db.delete(_db.invoices)..where((t) => t.id.equals(id))).go();
    });
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
  final Customer customer;
  final double totalBilled;
  final double totalPaid;
  final double totalOutstanding;
  final List<LedgerInvoiceRow> invoices;

  CustomerLedgerResult({
    required this.customer,
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
