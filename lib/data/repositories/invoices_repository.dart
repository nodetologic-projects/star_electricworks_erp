import 'package:drift/drift.dart' as import_drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/financial_year.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';

final invoicesRepositoryProvider = Provider((ref) {
  return InvoicesRepository(ref.watch(databaseProvider));
});

class InvoicesRepository {
  final AppDatabase _db;
  InvoicesRepository(this._db);

  Future<List<Invoice>> getAllInvoices() => (_db.select(_db.invoices)
        ..orderBy([
          (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
      .get();
  
  Stream<List<Invoice>> watchAllInvoices() => (_db.select(_db.invoices)
        ..orderBy([
          (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
      .watch();

  Stream<List<Invoice>> watchFilteredInvoices({String query = '', InvoiceType? type}) {
    final statement = _db.select(_db.invoices);
    
    if (query.isNotEmpty) {
      statement.where((t) => t.invoiceNo.like('%$query%'));
    }
    if (type != null) {
      statement.where((t) => t.invoiceType.equals(type.name));
    }
    
    statement.orderBy([
      (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    return statement.watch();
  }

  Future<Invoice> getInvoiceById(int id) {
    return (_db.select(_db.invoices)..where((t) => t.id.equals(id))).getSingle();
  }

  static String getPrefixForType(InvoiceType type) {
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

  String _getPrefixForType(InvoiceType type) => getPrefixForType(type);

  static int? parseSequenceNumber(String prefix, String label, String invoiceNo) {
    final clean = invoiceNo.trim().toUpperCase();
    final pfx = prefix.toUpperCase();
    final lbl = label.toUpperCase();

    // Standard format: e.g. INV-A0007, INV-AA0007
    final standardRegex = RegExp('^${RegExp.escape(pfx)}-([A-Z]+)(\\d+)\$');
    final standardMatch = standardRegex.firstMatch(clean);
    if (standardMatch != null) {
      final matchedLabel = standardMatch.group(1)!;
      if (matchedLabel.startsWith(lbl)) {
        return int.tryParse(standardMatch.group(2)!);
      }
    }

    // Simple prefix-number format: e.g. INV-7, INV-007
    final simpleRegex = RegExp('^${RegExp.escape(pfx)}-?(\\d+)\$');
    final simpleMatch = simpleRegex.firstMatch(clean);
    if (simpleMatch != null) {
      return int.tryParse(simpleMatch.group(1)!);
    }

    // Purely numeric: e.g. 7
    final numeric = int.tryParse(clean);
    if (numeric != null) {
      return numeric;
    }

    return null;
  }

  Future<bool> isInvoiceNumberTaken(String invoiceNo, {int? excludeInvoiceId}) async {
    final clean = invoiceNo.trim();
    if (clean.isEmpty) return false;
    final variables = <Variable>[
      Variable.withString(clean),
      if (excludeInvoiceId != null) Variable.withInt(excludeInvoiceId),
    ];
    final sql = 'SELECT id FROM invoices WHERE LOWER(TRIM(invoice_no)) = LOWER(TRIM(?))'
        '${excludeInvoiceId != null ? ' AND id != ?' : ''} LIMIT 1';
    final result = await _db.customSelect(sql, variables: variables).get();
    return result.isNotEmpty;
  }

  Future<({String invoiceNo, int sequenceNumber})> getNextInvoiceDetails(
    InvoiceType type,
    DateTime date,
  ) async {
    final prefix = getPrefixForType(type);
    final label = FinancialYear.getLabelForDate(date);

    final seqQuery = _db.select(_db.financialYearSequence)
      ..where((t) => t.invoiceTypePrefix.equals(prefix) & t.financialYearLabel.equals(label));
    final currentSeq = await seqQuery.getSingleOrNull();

    int candidateNumber = 1;
    if (currentSeq != null && currentSeq.lastNumber > 0) {
      candidateNumber = currentSeq.lastNumber + 1;
    }

    while (true) {
      final rolloverLabel = FinancialYear.getRolloverLabel(label, candidateNumber);
      final displayNum = ((candidateNumber - 1) % 5000) + 1;
      final candidateInvoiceNo = '$prefix-$rolloverLabel${displayNum.toString().padLeft(4, '0')}';

      final isTaken = await isInvoiceNumberTaken(candidateInvoiceNo);
      if (!isTaken) {
        return (invoiceNo: candidateInvoiceNo, sequenceNumber: candidateNumber);
      }
      candidateNumber++;
    }
  }

  Future<String> getNextInvoiceNumber(InvoiceType type, DateTime date) async {
    final details = await getNextInvoiceDetails(type, date);
    return details.invoiceNo;
  }

  Future<String?> checkSequenceGap(
    InvoiceType type,
    DateTime date,
    String invoiceNo,
  ) async {
    final prefix = getPrefixForType(type);
    final label = FinancialYear.getLabelForDate(date);
    final parsed = parseSequenceNumber(prefix, label, invoiceNo);
    if (parsed == null) return null;

    final nextDetails = await getNextInvoiceDetails(type, date);
    final expectedNext = nextDetails.sequenceNumber;

    if (parsed > expectedNext) {
      if (parsed == expectedNext + 1) {
        return 'Number $expectedNext was skipped';
      } else {
        return 'Numbers $expectedNext to ${parsed - 1} were skipped';
      }
    }
    return null;
  }

  Future<Invoice?> findDuplicateInvoice({
    required int customerId,
    required InvoiceType type,
    required double grandTotal,
    required DateTime date,
    int? excludeInvoiceId,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final query = _db.select(_db.invoices)
      ..where((t) {
        var expr = t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBetweenValues(startOfDay, endOfDay);
        if (excludeInvoiceId != null) {
          expr = expr & t.id.isNotValue(excludeInvoiceId);
        }
        return expr;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<int> createInvoiceWithItems(InvoicesCompanion invoice, List<InvoiceItemsCompanion> items) {
    return _db.transaction(() async {
      final typeEnum = invoice.invoiceType.value;
      final prefix = getPrefixForType(typeEnum);
      final date = invoice.invoiceDate.value;
      final label = FinancialYear.getLabelForDate(date);

      String finalInvoiceNo;
      if (invoice.invoiceNo.present &&
          invoice.invoiceNo.value.trim().isNotEmpty &&
          invoice.invoiceNo.value.trim() != 'PENDING') {
        finalInvoiceNo = invoice.invoiceNo.value.trim();
        final isTaken = await isInvoiceNumberTaken(finalInvoiceNo);
        if (isTaken) {
          throw Exception('Invoice number $finalInvoiceNo already exists');
        }
      } else {
        final nextDetails = await getNextInvoiceDetails(typeEnum, date);
        finalInvoiceNo = nextDetails.invoiceNo;
      }

      // Update FinancialYearSequence safely without corrupting it
      final parsedSeqNum = parseSequenceNumber(prefix, label, finalInvoiceNo);
      if (parsedSeqNum != null) {
        final seqQuery = _db.select(_db.financialYearSequence)
          ..where((t) => t.invoiceTypePrefix.equals(prefix) & t.financialYearLabel.equals(label));
        final currentSeq = await seqQuery.getSingleOrNull();
        final currentLast = currentSeq?.lastNumber ?? 0;

        if (parsedSeqNum > currentLast) {
          if (currentSeq != null) {
            await (_db.update(_db.financialYearSequence)..where((t) => t.id.equals(currentSeq.id)))
                .write(FinancialYearSequenceCompanion(lastNumber: Value(parsedSeqNum)));
          } else {
            await _db.into(_db.financialYearSequence).insert(
              FinancialYearSequenceCompanion.insert(
                invoiceTypePrefix: prefix,
                financialYearLabel: label,
                lastNumber: Value(parsedSeqNum),
              ),
            );
          }
        }
      }

      final finalInvoice = invoice.copyWith(invoiceNo: Value(finalInvoiceNo));
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
                notes: Value('Invoice $finalInvoiceNo'),
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

      Value<String> invoiceNoToUpdate = const Value.absent();
      if (invoiceCompanion.invoiceNo.present) {
        final newNo = invoiceCompanion.invoiceNo.value.trim();
        if (newNo.isNotEmpty && newNo.toLowerCase() != existingInvoice.invoiceNo.toLowerCase()) {
          final isTaken = await isInvoiceNumberTaken(newNo, excludeInvoiceId: invoiceId);
          if (isTaken) {
            throw Exception('Invoice number $newNo already exists');
          }
          invoiceNoToUpdate = Value(newNo);

          // Update sequence if applicable
          final typeEnum = invoiceCompanion.invoiceType.present ? invoiceCompanion.invoiceType.value : existingInvoice.invoiceType;
          final prefix = getPrefixForType(typeEnum);
          final dateForSeq = invoiceCompanion.invoiceDate.present ? invoiceCompanion.invoiceDate.value : existingInvoice.invoiceDate;
          final label = FinancialYear.getLabelForDate(dateForSeq);
          final parsedSeqNum = parseSequenceNumber(prefix, label, newNo);
          if (parsedSeqNum != null) {
            final seqQuery = _db.select(_db.financialYearSequence)
              ..where((t) => t.invoiceTypePrefix.equals(prefix) & t.financialYearLabel.equals(label));
            final currentSeq = await seqQuery.getSingleOrNull();
            final currentLast = currentSeq?.lastNumber ?? 0;
            if (parsedSeqNum > currentLast) {
              if (currentSeq != null) {
                await (_db.update(_db.financialYearSequence)..where((t) => t.id.equals(currentSeq.id)))
                    .write(FinancialYearSequenceCompanion(lastNumber: Value(parsedSeqNum)));
              } else {
                await _db.into(_db.financialYearSequence).insert(
                  FinancialYearSequenceCompanion.insert(
                    invoiceTypePrefix: prefix,
                    financialYearLabel: label,
                    lastNumber: Value(parsedSeqNum),
                  ),
                );
              }
            }
          }
        }
      }

      final updateCompanion = invoiceCompanion.copyWith(
        invoiceNo: invoiceNoToUpdate, 
        invoiceDate: existingInvoice.status == InvoiceStatus.draft && invoiceCompanion.invoiceDate.present
            ? invoiceCompanion.invoiceDate
            : const Value.absent(),
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
                notes: Value('Invoice ${invoiceNoToUpdate.present ? invoiceNoToUpdate.value : existingInvoice.invoiceNo} (Edited)'),
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
      ..orderBy([
        OrderingTerm(expression: _db.invoices.invoiceDate, mode: OrderingMode.desc),
        OrderingTerm(expression: _db.invoices.createdAt, mode: OrderingMode.desc),
      ])
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
      ..orderBy([
        OrderingTerm(expression: _db.invoices.invoiceDate, mode: OrderingMode.desc),
        OrderingTerm(expression: _db.invoices.createdAt, mode: OrderingMode.desc),
      ]);

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
      ..orderBy([
        (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
      ]);

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
        igst: current.igst + inv.igstAmount,
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
      ..orderBy([
        (t) => OrderingTerm(expression: t.paymentDate, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
    ).get();
  }

  Future<void> updatePayment(PaymentsCompanion payment) async {
    await _db.transaction(() async {
      await _db.update(_db.payments).replace(payment);
      final invoiceId = payment.invoiceId.value;
      final allPayments = await getPaymentsForInvoice(invoiceId);
      final totalPaid = allPayments.fold<double>(0.0, (sum, p) => sum + p.amount);
      final invoice = await getInvoiceById(invoiceId);
      InvoiceStatus newStatus = invoice.status;
      if (totalPaid >= invoice.grandTotal) {
        newStatus = InvoiceStatus.paid;
      } else if (totalPaid > 0) {
        newStatus = InvoiceStatus.sent;
      }
      if (newStatus != invoice.status) {
        await updateInvoiceStatus(invoiceId, newStatus);
      }
    });
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
    final invoices = await (_db.select(_db.invoices)..where((t) =>
      t.invoiceType.isIn([
        InvoiceType.serviceTaxInvoice.name,
        InvoiceType.salesTaxInvoice.name,
        InvoiceType.billOfSupply.name,
      ])
    )).get();
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
      ..orderBy([
        (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
      ]);
      
    final invoices = await query.get();
    
    // Only customer-billing documents with a value (Service Tax Invoice, Sales Tax Invoice, Bill of Supply)
    // Include EVERY saved billing invoice regardless of status (draft/pending, sent, paid, partiallyPaid, overdue)
    // Exclude only Delivery Challans and Purchase Vouchers
    final billingInvoices = invoices.where((inv) =>
      inv.invoiceType == InvoiceType.serviceTaxInvoice ||
      inv.invoiceType == InvoiceType.salesTaxInvoice ||
      inv.invoiceType == InvoiceType.billOfSupply
    ).toList();
    
    final invoiceIds = billingInvoices.map((i) => i.id).toSet();
    final allPayments = invoiceIds.isEmpty ? <Payment>[] : await (_db.select(_db.payments)..where((t) => t.invoiceId.isIn(invoiceIds))).get();
    
    double totalBilled = 0.0;
    double totalPaid = 0.0;
    double runningBalance = 0.0;
    List<LedgerInvoiceRow> chronologicalRows = [];
    
    for (var inv in billingInvoices) {
      totalBilled += inv.grandTotal;
      
      final paymentsForInv = allPayments.where((p) => p.invoiceId == inv.id).fold<double>(0.0, (s, p) => s + p.amount);
      totalPaid += paymentsForInv;
      final balanceDue = inv.grandTotal - paymentsForInv;

      runningBalance += balanceDue;
      
      chronologicalRows.add(LedgerInvoiceRow(
        invoice: inv,
        totalPaid: paymentsForInv,
        balanceDue: balanceDue,
        runningBalance: runningBalance,
      ));
    }
    
    // Reverse so the screen shows newest first, while each row retains its chronological running balance
    final displayRows = chronologicalRows.reversed.toList();

    return CustomerLedgerResult(
      customer: customer,
      totalBilled: totalBilled,
      totalPaid: totalPaid,
      totalOutstanding: totalBilled - totalPaid,
      invoices: displayRows,
    );
  }

  Future<CustomerLedgerStatement> getCustomerLedgerStatement({
    required int customerId,
    required DateTime? fromDate,
    required DateTime toDate,
  }) async {
    final customer = await (_db.select(_db.customers)..where((t) => t.id.equals(customerId))).getSingle();
    final normToDate = IstDateUtils.toMidnightIst(toDate);
    final endOfToDate = DateTime(normToDate.year, normToDate.month, normToDate.day, 23, 59, 59, 999);
    final normFromDate = fromDate != null ? IstDateUtils.toMidnightIst(fromDate) : null;

    final query = _db.select(_db.invoices)..where((t) => t.customerId.equals(customerId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
      ]);
      
    final allInvoices = await query.get();
    final billingInvoices = allInvoices.where((inv) =>
      inv.invoiceType == InvoiceType.serviceTaxInvoice ||
      inv.invoiceType == InvoiceType.salesTaxInvoice ||
      inv.invoiceType == InvoiceType.billOfSupply
    ).toList();

    final invoiceIds = billingInvoices.map((i) => i.id).toSet();
    final allPayments = invoiceIds.isEmpty
        ? <Payment>[]
        : await (_db.select(_db.payments)..where((t) => t.invoiceId.isIn(invoiceIds))).get();

    final List<_LedgerTimelineEvent> events = [];

    for (final inv in billingInvoices) {
      String typeLabel;
      switch (inv.invoiceType) {
        case InvoiceType.serviceTaxInvoice:
          typeLabel = 'Service Tax Invoice';
          break;
        case InvoiceType.salesTaxInvoice:
          typeLabel = 'Sales Tax Invoice';
          break;
        case InvoiceType.billOfSupply:
          typeLabel = 'Bill of Supply';
          break;
        default:
          typeLabel = 'Invoice';
      }

      final paymentsForInv = allPayments.where((p) => p.invoiceId == inv.id).fold<double>(0.0, (s, p) => s + p.amount);
      final balanceDue = inv.grandTotal - paymentsForInv;
      String statusLabel;
      if (balanceDue <= 0.001) {
        statusLabel = 'Paid';
      } else if (paymentsForInv > 0.001) {
        statusLabel = 'Partially Paid';
      } else {
        final now = IstDateUtils.nowIst();
        final isOverdue = inv.status == InvoiceStatus.overdue ||
            (inv.dueDate != null && IstDateUtils.toMidnightIst(inv.dueDate!).isBefore(IstDateUtils.toMidnightIst(now)));
        if (isOverdue) {
          statusLabel = 'Overdue';
        } else {
          statusLabel = 'Unpaid';
        }
      }

      events.add(_LedgerTimelineEvent(
        date: IstDateUtils.toMidnightIst(inv.invoiceDate),
        createdAt: inv.createdAt,
        isDebit: true,
        amount: inv.grandTotal,
        document: '$typeLabel - ${inv.invoiceNo}',
        status: statusLabel,
      ));
    }

    for (final p in allPayments) {
      String modeStr;
      switch (p.paymentMode) {
        case PaymentMode.cash:
          modeStr = 'Cash';
          break;
        case PaymentMode.bankTransfer:
          modeStr = 'Bank Transfer';
          break;
        case PaymentMode.upi:
          modeStr = 'UPI';
          break;
        case PaymentMode.cheque:
          modeStr = 'Cheque';
          break;
      }
      final refStr = (p.referenceNo != null && p.referenceNo!.trim().isNotEmpty)
          ? ' (Ref: ${p.referenceNo!.trim()})'
          : '';
      events.add(_LedgerTimelineEvent(
        date: IstDateUtils.toMidnightIst(p.paymentDate),
        createdAt: p.createdAt,
        isDebit: false,
        amount: p.amount,
        document: 'Payment Received - $modeStr$refStr',
        status: null,
      ));
    }

    // Sort chronologically:
    // 1. by date ASC
    // 2. on same date: Invoices (Debit) before Payments (Credit)
    // 3. then by createdAt ASC
    events.sort((a, b) {
      final dateCmp = a.date.compareTo(b.date);
      if (dateCmp != 0) return dateCmp;
      final typeCmp = (a.isDebit ? 0 : 1).compareTo(b.isDebit ? 0 : 1);
      if (typeCmp != 0) return typeCmp;
      return a.createdAt.compareTo(b.createdAt);
    });

    double openingBalance = 0.0;
    final List<_LedgerTimelineEvent> inPeriodEvents = [];

    for (final ev in events) {
      if (normFromDate != null && ev.date.isBefore(normFromDate)) {
        if (ev.isDebit) {
          openingBalance += ev.amount;
        } else {
          openingBalance -= ev.amount;
        }
      } else if (!ev.date.isAfter(endOfToDate)) {
        inPeriodEvents.add(ev);
      }
    }

    double runningBalance = openingBalance;
    double totalDebit = 0.0;
    double totalCredit = 0.0;
    final List<CustomerLedgerStatementEntry> statementEntries = [];

    for (final ev in inPeriodEvents) {
      if (ev.isDebit) {
        totalDebit += ev.amount;
        runningBalance += ev.amount;
        statementEntries.add(CustomerLedgerStatementEntry(
          date: ev.date,
          document: ev.document,
          status: ev.status,
          debit: ev.amount,
          credit: null,
          runningBalance: runningBalance,
        ));
      } else {
        totalCredit += ev.amount;
        runningBalance -= ev.amount;
        statementEntries.add(CustomerLedgerStatementEntry(
          date: ev.date,
          document: ev.document,
          status: null,
          debit: null,
          credit: ev.amount,
          runningBalance: runningBalance,
        ));
      }
    }

    return CustomerLedgerStatement(
      customer: customer,
      fromDate: normFromDate,
      toDate: normToDate,
      isAllTime: normFromDate == null,
      openingBalance: openingBalance,
      entries: statementEntries,
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      closingBalance: runningBalance,
    );
  }

  Future<CustomerOutstandingStatement> getCustomerOutstandingStatement({
    required int customerId,
    DateTime? asOfDate,
  }) async {
    final customer = await (_db.select(_db.customers)..where((t) => t.id.equals(customerId))).getSingle();
    final effectiveAsOfDate = IstDateUtils.toMidnightIst(asOfDate ?? IstDateUtils.nowIst());

    final query = _db.select(_db.invoices)..where((t) => t.customerId.equals(customerId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
      ]);

    final allInvoices = await query.get();
    final billingInvoices = allInvoices.where((inv) =>
      inv.invoiceType == InvoiceType.serviceTaxInvoice ||
      inv.invoiceType == InvoiceType.salesTaxInvoice ||
      inv.invoiceType == InvoiceType.billOfSupply
    ).toList();

    final invoiceIds = billingInvoices.map((i) => i.id).toSet();
    final allPayments = invoiceIds.isEmpty
        ? <Payment>[]
        : await (_db.select(_db.payments)..where((t) => t.invoiceId.isIn(invoiceIds))).get();

    final List<CustomerOutstandingBill> bills = [];

    for (final inv in billingInvoices) {
      final paymentsForInv = allPayments.where((p) => p.invoiceId == inv.id).fold<double>(0.0, (s, p) => s + p.amount);
      final balanceDue = inv.grandTotal - paymentsForInv;

      if (balanceDue > 0.001) {
        int daysOverdue = 0;
        if (inv.dueDate != null) {
          final due = IstDateUtils.toMidnightIst(inv.dueDate!);
          if (effectiveAsOfDate.isAfter(due)) {
            daysOverdue = effectiveAsOfDate.difference(due).inDays;
          }
        }

        bills.add(CustomerOutstandingBill(
          invoice: inv,
          invoiceNo: inv.invoiceNo,
          invoiceDate: IstDateUtils.toMidnightIst(inv.invoiceDate),
          dueDate: inv.dueDate != null ? IstDateUtils.toMidnightIst(inv.dueDate!) : null,
          billAmount: inv.grandTotal,
          amountPaid: paymentsForInv,
          balanceDue: balanceDue,
          daysOverdue: daysOverdue,
        ));
      }
    }

    // Sorted oldest first (invoiceDate ASC, then createdAt ASC)
    bills.sort((a, b) {
      final dateCmp = a.invoiceDate.compareTo(b.invoiceDate);
      if (dateCmp != 0) return dateCmp;
      return a.invoice.createdAt.compareTo(b.invoice.createdAt);
    });

    final totalBillAmount = bills.fold<double>(0.0, (s, b) => s + b.billAmount);
    final totalAmountPaid = bills.fold<double>(0.0, (s, b) => s + b.amountPaid);
    final totalOutstanding = bills.fold<double>(0.0, (s, b) => s + b.balanceDue);

    return CustomerOutstandingStatement(
      customer: customer,
      asOfDate: effectiveAsOfDate,
      bills: bills,
      totalBillAmount: totalBillAmount,
      totalAmountPaid: totalAmountPaid,
      totalOutstanding: totalOutstanding,
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
  final double runningBalance;

  LedgerInvoiceRow({
    required this.invoice,
    required this.totalPaid,
    required this.balanceDue,
    required this.runningBalance,
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

class _LedgerTimelineEvent {
  final DateTime date;
  final DateTime createdAt;
  final bool isDebit;
  final double amount;
  final String document;
  final String? status;

  _LedgerTimelineEvent({
    required this.date,
    required this.createdAt,
    required this.isDebit,
    required this.amount,
    required this.document,
    this.status,
  });
}

class CustomerLedgerStatementEntry {
  final DateTime date;
  final String document;
  final String? status;
  final double? debit;
  final double? credit;
  final double runningBalance;

  CustomerLedgerStatementEntry({
    required this.date,
    required this.document,
    this.status,
    this.debit,
    this.credit,
    required this.runningBalance,
  });
}

class CustomerLedgerStatement {
  final Customer customer;
  final DateTime? fromDate;
  final DateTime toDate;
  final bool isAllTime;
  final double openingBalance;
  final List<CustomerLedgerStatementEntry> entries;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;

  CustomerLedgerStatement({
    required this.customer,
    required this.fromDate,
    required this.toDate,
    required this.isAllTime,
    required this.openingBalance,
    required this.entries,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });
}

class CustomerOutstandingBill {
  final Invoice invoice;
  final String invoiceNo;
  final DateTime invoiceDate;
  final DateTime? dueDate;
  final double billAmount;
  final double amountPaid;
  final double balanceDue;
  final int daysOverdue;

  CustomerOutstandingBill({
    required this.invoice,
    required this.invoiceNo,
    required this.invoiceDate,
    this.dueDate,
    required this.billAmount,
    required this.amountPaid,
    required this.balanceDue,
    required this.daysOverdue,
  });
}

class CustomerOutstandingStatement {
  final Customer customer;
  final DateTime asOfDate;
  final List<CustomerOutstandingBill> bills;
  final double totalBillAmount;
  final double totalAmountPaid;
  final double totalOutstanding;

  CustomerOutstandingStatement({
    required this.customer,
    required this.asOfDate,
    required this.bills,
    required this.totalBillAmount,
    required this.totalAmountPaid,
    required this.totalOutstanding,
  });
}
