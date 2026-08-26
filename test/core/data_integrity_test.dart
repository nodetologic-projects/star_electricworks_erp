import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Hard Delete: Attempting to delete a Customer referenced by an Invoice', () async {
    // 1. Create Customer
    final customerId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Test Corp',
        address: '123 Test St',
        state: 'Gujarat',
        phone: '1234567890',
        email: 'test@test.com',
      ),
    );

    // 2. Create Invoice referencing Customer
    await db.into(db.invoices).insert(
      InvoicesCompanion.insert(
        invoiceNo: 'INV-001',
        invoiceType: InvoiceType.salesTaxInvoice,
        customerId: customerId,
        invoiceDate: DateTime.now(),
        subtotal: 1000.0,
        cgstAmount: 90.0,
        sgstAmount: 90.0,
        igstAmount: Value(0.0),
        discountAmount: 0.0,
        grandTotal: 1180.0,
        status: InvoiceStatus.draft,
        amountInWords: 'One thousand',
      ),
    );

    // 3. Attempt to delete Customer
    bool threwError = false;
    try {
      await (db.delete(db.customers)..where((t) => t.id.equals(customerId))).go();
    } catch (e) {
      threwError = true;
      print('Deletion failed with error: $e');
    }

    final invoices = await db.select(db.invoices).get();
    print('Customer deleted successfully? ${!threwError}. Invoices remaining: ${invoices.length}');
    
    // We expect the SQLite to let it happen if FKs are disabled, OR throw if they are enabled.
    // If it deletes, we expect the invoice to have a dangling customerId. Let's see what happens.
  });

  test('Soft Delete: Copper Stock deduction and relation via InvoiceItems', () async {
    final stockId = await db.into(db.copperStock).insert(
      CopperStockCompanion.insert(
        copperType: CopperType.newCopper,
        description: 'Test Stock',
        weightKg: 100.0,
        pricePerKg: 500.0,
        stockQtyKg: 100.0,
      ),
    );

    final custId = await db.into(db.customers).insert(
      CustomersCompanion.insert(name: 'Test', address: '', state: '', phone: '', email: '')
    );
    final invId = await db.into(db.invoices).insert(
      InvoicesCompanion.insert(
        invoiceNo: 'T', 
        invoiceType: InvoiceType.salesTaxInvoice, 
        customerId: custId, 
        invoiceDate: DateTime.now(), 
        subtotal: 0, 
        cgstAmount: 0, 
        sgstAmount: 0, 
        igstAmount: Value(0.0), 
        discountAmount: 0,
        grandTotal: 0, 
        status: InvoiceStatus.draft,
        amountInWords: 'Zero'
      )
    );

    await db.into(db.invoiceItems).insert(
      InvoiceItemsCompanion.insert(
        invoiceId: invId,
        itemSourceType: ItemSourceType.copperStock,
        copperStockId: Value(stockId),
        description: 'Test Stock Item',
        qty: const Value(10.0),
        unitPrice: 500.0,
        lineTotal: 5000.0,
      ),
    );

    await db.update(db.copperStock).replace(
      CopperStockCompanion(
        id: Value(stockId), 
        copperType: Value(CopperType.newCopper),
        description: Value('Test Stock'),
        weightKg: Value(100.0),
        pricePerKg: Value(500.0),
        stockQtyKg: Value(100.0),
        isActive: const Value(false)
      ),
    );

    final item = await (db.select(db.invoiceItems)..where((t) => t.copperStockId.equals(stockId))).getSingle();
    final stock = await (db.select(db.copperStock)..where((t) => t.id.equals(item.copperStockId!))).getSingle();
    
    expect(stock.description, 'Test Stock');
    expect(stock.isActive, false);
    print('Soft delete test passed. Item resolves to historical inactive stock.');
  });
}
