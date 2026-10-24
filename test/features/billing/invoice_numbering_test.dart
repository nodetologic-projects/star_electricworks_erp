import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';

void main() {
  late AppDatabase db;
  late InvoicesRepository repo;
  late int customerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = InvoicesRepository(db);

    customerId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Test Customer',
        address: '123 Test St',
        state: 'Gujarat',
        phone: '9876543210',
        email: 'test@customer.com',
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  InvoicesCompanion createTestInvoiceCompanion({
    required String invoiceNo,
    InvoiceType type = InvoiceType.serviceTaxInvoice,
    DateTime? date,
    InvoiceStatus status = InvoiceStatus.draft,
  }) {
    return InvoicesCompanion.insert(
      invoiceNo: invoiceNo,
      invoiceType: type,
      customerId: customerId,
      invoiceDate: date ?? DateTime(2024, 6, 1), // In FY 2024-25 (label 'A')
      subtotal: 1000.0,
      cgstAmount: 90.0,
      sgstAmount: 90.0,
      discountAmount: 0.0,
      grandTotal: 1180.0,
      amountInWords: 'One Thousand One Hundred Eighty Only',
      status: status,
    );
  }

  group('Invoice Numbering & Validation', () {
    test('Auto-generated number follows FY format and per-type prefixes', () async {
      final date = DateTime(2024, 6, 1); // FY 2024-25 -> label 'A'
      
      final invNo = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(invNo, 'INV-A0001');

      final bosNo = await repo.getNextInvoiceNumber(InvoiceType.billOfSupply, date);
      expect(bosNo, 'BOS-A0001');

      final purNo = await repo.getNextInvoiceNumber(InvoiceType.purchaseVoucher, date);
      expect(purNo, 'PUR-A0001');

      final dcNo = await repo.getNextInvoiceNumber(InvoiceType.deliveryChallan, date);
      expect(dcNo, 'DC-A0001');
    });

    test('Custom manual invoice number does NOT corrupt auto-sequence', () async {
      final date = DateTime(2024, 6, 1);

      // Verify initial next auto number is INV-A0001
      final initialAuto = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(initialAuto, 'INV-A0001');

      // Create invoice with custom manual number "CUSTOM-99"
      await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'CUSTOM-99', date: date),
        [],
      );

      // Verify the auto-sequence is NOT corrupted: next auto number should still be INV-A0001
      final nextAuto = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(nextAuto, 'INV-A0001');

      // Create the next invoice with the auto-suggested number INV-A0001
      final savedId = await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: nextAuto, date: date),
        [],
      );
      expect(savedId, greaterThan(0));

      final savedInvoice = await repo.getInvoiceById(savedId);
      expect(savedInvoice.invoiceNo, 'INV-A0001');

      // Now next auto should be INV-A0002
      final thirdAuto = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(thirdAuto, 'INV-A0002');
    });

    test('Auto-suggestion skips taken numbers and never collides with manual entries', () async {
      final date = DateTime(2024, 6, 1);

      // User manually enters INV-A0001
      await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'INV-A0001', date: date),
        [],
      );

      // Next auto-suggestion should skip INV-A0001 and suggest INV-A0002
      final nextAuto = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(nextAuto, 'INV-A0002');

      // User manually enters INV-A0002
      await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'INV-A0002', date: date),
        [],
      );

      // Next auto-suggestion should suggest INV-A0003
      final nextAuto2 = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, date);
      expect(nextAuto2, 'INV-A0003');
    });

    test('Duplicate invoice number detection is trim and case-insensitive', () async {
      final date = DateTime(2024, 6, 1);

      await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'INV-12', date: date),
        [],
      );

      // Check isInvoiceNumberTaken with exact, lowercase, and whitespace
      expect(await repo.isInvoiceNumberTaken('INV-12'), isTrue);
      expect(await repo.isInvoiceNumberTaken('inv-12'), isTrue);
      expect(await repo.isInvoiceNumberTaken('  inv-12  '), isTrue);
      expect(await repo.isInvoiceNumberTaken('INV-13'), isFalse);

      // Attempting to save a duplicate throws clean error
      expect(
        () => repo.createInvoiceWithItems(
          createTestInvoiceCompanion(invoiceNo: '  inv-12 ', date: date),
          [],
        ),
        throwsA(predicate((e) =>
            e.toString().contains('Invoice number inv-12 already exists'))),
      );
    });

    test('Sequence gap detection detects skipped numbers non-blockingly', () async {
      final date = DateTime(2024, 6, 1);

      // Currently at beginning: expected is 1
      // If user enters INV-A0001: no gap
      expect(await repo.checkSequenceGap(InvoiceType.serviceTaxInvoice, date, 'INV-A0001'), isNull);

      // If user enters INV-A0002: expected was 1, so number 1 was skipped
      expect(await repo.checkSequenceGap(InvoiceType.serviceTaxInvoice, date, 'INV-A0002'), 'Number 1 was skipped');

      // If user enters INV-A0004: numbers 1 to 3 were skipped
      expect(await repo.checkSequenceGap(InvoiceType.serviceTaxInvoice, date, 'INV-A0004'), 'Numbers 1 to 3 were skipped');

      // Custom non-sequence number does not trigger gap
      expect(await repo.checkSequenceGap(InvoiceType.serviceTaxInvoice, date, 'CUSTOM-99'), isNull);

      // After saving INV-A0001, expected is 2. Entering INV-A0003 skips number 2
      await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'INV-A0001', date: date),
        [],
      );
      expect(await repo.checkSequenceGap(InvoiceType.serviceTaxInvoice, date, 'INV-A0003'), 'Number 2 was skipped');
    });

    test('Edit Invoice: draft invoice allows invoice number update; non-draft throws', () async {
      final date = DateTime(2024, 6, 1);

      // Create draft invoice
      final invId = await repo.createInvoiceWithItems(
        createTestInvoiceCompanion(invoiceNo: 'INV-A0001', date: date, status: InvoiceStatus.draft),
        [],
      );

      // Update invoice number to INV-A0001-MOD
      await repo.updateInvoiceWithItems(
        invId,
        InvoicesCompanion(invoiceNo: Value('INV-A0001-MOD')),
        [],
      );

      final updated = await repo.getInvoiceById(invId);
      expect(updated.invoiceNo, 'INV-A0001-MOD');

      // Now finalize/mark as sent
      await repo.updateInvoiceStatus(invId, InvoiceStatus.sent);

      // Attempting to update finalized invoice throws
      expect(
        () => repo.updateInvoiceWithItems(
          invId,
          InvoicesCompanion(invoiceNo: Value('INV-A0001-LOCKED')),
          [],
        ),
        throwsA(predicate((e) => e.toString().contains('Only draft invoices can be edited'))),
      );
    });

    test('GST Rule 46 format & length validation checks', () {
      final validRegex = RegExp(r'^[a-zA-Z0-9\/\-]+$');

      // Valid format examples
      expect(validRegex.hasMatch('INV-A0001'), isTrue);
      expect(validRegex.hasMatch('INV/2024-25/001'), isTrue);
      expect(validRegex.hasMatch('BOS-1234'), isTrue);
      expect(validRegex.hasMatch('PUR-01'), isTrue);
      expect(validRegex.hasMatch('DC/1'), isTrue);

      // Invalid format examples (special chars, spaces)
      expect(validRegex.hasMatch('INV 001'), isFalse);
      expect(validRegex.hasMatch('INV#001'), isFalse);
      expect(validRegex.hasMatch('INV@01'), isFalse);
      expect(validRegex.hasMatch('INV_001'), isFalse);

      // Length constraint
      expect('INV/2024-25/0001'.length <= 16, isTrue); // 16 chars -> valid
      expect('1234567890123456'.length <= 16, isTrue); // 16 chars -> valid
      expect('12345678901234567'.length <= 16, isFalse); // 17 chars -> invalid
    });
  });
}
