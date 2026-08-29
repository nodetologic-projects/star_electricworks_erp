import sys

with open("lib/data/repositories/invoices_repository.dart", "r") as f:
    content = f.read()

target = "Future<List<InvoiceItem>> getItemsForInvoice(int invoiceId) {"

patch = """
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

"""

if patch in content:
    print("Already patched")
    sys.exit(0)

new_content = content.replace(target, patch + target)
with open("lib/data/repositories/invoices_repository.dart", "w") as f:
    f.write(new_content)

print("Patched repo")
