import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/financial_year.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

void main() {
  late AppDatabase db;
  late InvoicesRepository repo;
  late int customerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = InvoicesRepository(db);

    customerId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Alpha Industries',
        address: '100 Industrial Area, Ahmedabad',
        state: 'Gujarat',
        phone: '9876543210',
        email: 'alpha@example.com',
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Date Field Normalization & Backdating Rules', () {
    test('Create backdated invoice in a previous FY follows that FY series and midnight IST', () async {
      // Current FY (2026-27 -> series 'C'). Previous FY (2024-25 -> series 'A')
      final backdatedDate = IstDateUtils.toMidnightIst(DateTime(2024, 6, 15));
      expect(FinancialYear.getLabelForDate(backdatedDate), 'A');

      final autoInvoiceNo = await repo.getNextInvoiceNumber(
        InvoiceType.serviceTaxInvoice,
        backdatedDate,
      );
      expect(autoInvoiceNo, 'INV-A0001');

      final invId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: autoInvoiceNo,
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: backdatedDate,
          subtotal: 5000,
          cgstAmount: 450,
          sgstAmount: 450,
          discountAmount: 0,
          grandTotal: 5900,
          amountInWords: 'Five Thousand Nine Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      final saved = await repo.getInvoiceById(invId);
      expect(saved.invoiceNo, 'INV-A0001');
      expect(saved.invoiceDate.year, 2024);
      expect(saved.invoiceDate.month, 6);
      expect(saved.invoiceDate.day, 15);
      expect(saved.invoiceDate.hour, 0);
      expect(saved.invoiceDate.minute, 0);
    });

    test('Future-dated payment can be recorded and normalized to midnight IST', () async {
      final invDate = IstDateUtils.toMidnightIst(DateTime(2026, 10, 29));
      final invId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: invDate,
          subtotal: 1000,
          cgstAmount: 90,
          sgstAmount: 90,
          discountAmount: 0,
          grandTotal: 1180,
          amountInWords: 'One Thousand One Hundred Eighty Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Future-dated payment in 2028
      final futureDate = IstDateUtils.toMidnightIst(DateTime(2028, 1, 15));
      expect(futureDate.isAfter(DateTime(2026, 10, 29)), isTrue);

      final paymentId = await repo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 1180,
          paymentMode: PaymentMode.bankTransfer,
          paymentDate: futureDate,
          referenceNo: const drift.Value('NEFT-FUTURE-999'),
        ),
      );

      final payments = await repo.getPaymentsForInvoice(invId);
      expect(payments.length, 1);
      expect(payments.first.id, paymentId);
      expect(payments.first.paymentDate.year, 2028);
      expect(payments.first.paymentDate.month, 1);
      expect(payments.first.paymentDate.day, 15);
      expect(payments.first.paymentDate.hour, 0);
    });

    test('Edit a draft invoice date: updates invoice date and allows updating invoice number & due date', () async {
      // Start in FY 2026-27 (series C)
      final originalDate = IstDateUtils.toMidnightIst(DateTime(2026, 5, 1));
      const paymentTerm = 15;
      final originalDueDate = originalDate.add(const Duration(days: paymentTerm));

      final originalNo = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, originalDate);
      expect(originalNo, 'INV-C0001');

      final invId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: originalNo,
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: originalDate,
          dueDate: drift.Value(originalDueDate),
          paymentTermDays: const drift.Value(paymentTerm),
          subtotal: 2000,
          cgstAmount: 180,
          sgstAmount: 180,
          discountAmount: 0,
          grandTotal: 2360,
          amountInWords: 'Two Thousand Three Hundred Sixty Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Now edit draft's date to FY 2025-26 (series B)
      final newDate = IstDateUtils.toMidnightIst(DateTime(2025, 5, 1));
      final newDueDate = newDate.add(const Duration(days: paymentTerm));
      final newSuggestedNo = await repo.getNextInvoiceNumber(InvoiceType.serviceTaxInvoice, newDate);
      expect(newSuggestedNo, 'INV-B0001');

      await repo.updateInvoiceWithItems(
        invId,
        InvoicesCompanion(
          invoiceNo: drift.Value(newSuggestedNo),
          invoiceDate: drift.Value(newDate),
          dueDate: drift.Value(newDueDate),
        ),
        [],
      );

      final updated = await repo.getInvoiceById(invId);
      expect(updated.invoiceNo, 'INV-B0001');
      expect(updated.invoiceDate.year, 2025);
      expect(updated.invoiceDate.month, 5);
      expect(updated.invoiceDate.day, 1);
      expect(updated.dueDate?.day, 16);
      expect(updated.dueDate?.month, 5);
      expect(updated.dueDate?.year, 2025);
    });

    test('Finalized/sent invoice keeps date locked and ignores invoice date edits', () async {
      final originalDate = IstDateUtils.toMidnightIst(DateTime(2026, 4, 10));
      final invId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0002',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: originalDate,
          subtotal: 1000,
          cgstAmount: 90,
          sgstAmount: 90,
          discountAmount: 0,
          grandTotal: 1180,
          amountInWords: 'One Thousand One Hundred Eighty Only',
          status: InvoiceStatus.sent, // Non-draft (finalized)
        ),
        [],
      );

      // Attempt to update invoice date on sent invoice - must throw Exception
      final attemptDate = IstDateUtils.toMidnightIst(DateTime(2025, 1, 1));
      expect(
        () => repo.updateInvoiceWithItems(
          invId,
          InvoicesCompanion(
            invoiceDate: drift.Value(attemptDate),
          ),
          [],
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Only draft invoices can be edited'),
        )),
      );

      final inv = await repo.getInvoiceById(invId);
      // Must stay originalDate
      expect(inv.invoiceDate.year, 2026);
      expect(inv.invoiceDate.month, 4);
      expect(inv.invoiceDate.day, 10);
    });

    test('Duplicate invoice detection compares on entered invoice date, not today', () async {
      final backdate = IstDateUtils.toMidnightIst(DateTime(2025, 2, 14));
      
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-B0010',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: backdate,
          subtotal: 3000,
          cgstAmount: 270,
          sgstAmount: 270,
          discountAmount: 0,
          grandTotal: 3540,
          amountInWords: 'Three Thousand Five Hundred Forty Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Querying with today's date should NOT find the backdated invoice
      final dupToday = await repo.findDuplicateInvoice(
        customerId: customerId,
        type: InvoiceType.salesTaxInvoice,
        grandTotal: 3540,
        date: DateTime.now(),
      );
      expect(dupToday, isNull);

      // Querying with the entered invoice date SHOULD find the duplicate
      final dupBackdated = await repo.findDuplicateInvoice(
        customerId: customerId,
        type: InvoiceType.salesTaxInvoice,
        grandTotal: 3540,
        date: backdate,
      );
      expect(dupBackdated, isNotNull);
      expect(dupBackdated!.invoiceNo, 'INV-B0010');
    });

    test('Ledger running balance is correct after inserting a backdated invoice between two existing ones', () async {
      // 1. First invoice on 2026-01-01 for ₹1000
      final inv1Date = IstDateUtils.toMidnightIst(DateTime(2026, 1, 1));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-01',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv1Date,
          subtotal: 1000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 1000,
          amountInWords: 'One Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // 2. Second invoice on 2026-03-01 for ₹500
      final inv2Date = IstDateUtils.toMidnightIst(DateTime(2026, 3, 1));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-02',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv2Date,
          subtotal: 500,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 500,
          amountInWords: 'Five Hundred Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Check ledger before backdating
      var ledger = await repo.getCustomerLedger(customerId);
      expect(ledger.invoices.length, 2);
      // Newest first in returned list:
      // Index 0: INV-02 (2026-03-01) -> running balance = 1500
      // Index 1: INV-01 (2026-01-01) -> running balance = 1000
      expect(ledger.invoices[0].invoice.invoiceNo, 'INV-02');
      expect(ledger.invoices[0].runningBalance, 1500.0);
      expect(ledger.invoices[1].invoice.invoiceNo, 'INV-01');
      expect(ledger.invoices[1].runningBalance, 1000.0);
      expect(ledger.totalOutstanding, 1500.0);

      // 3. Now insert a backdated invoice between them on 2026-02-01 for ₹200
      final inv3Date = IstDateUtils.toMidnightIst(DateTime(2026, 2, 1));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-03-BACKDATED',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv3Date,
          subtotal: 200,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 200,
          amountInWords: 'Two Hundred Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Check ledger after backdating:
      // Chronological order should be:
      // 1. INV-01 (Jan 1): ₹1000 -> Running Bal = 1000
      // 2. INV-03 (Feb 1): ₹200  -> Running Bal = 1200
      // 3. INV-02 (Mar 1): ₹500  -> Running Bal = 1700
      ledger = await repo.getCustomerLedger(customerId);
      expect(ledger.invoices.length, 3);
      expect(ledger.totalOutstanding, 1700.0);

      // Displayed newest first:
      expect(ledger.invoices[0].invoice.invoiceNo, 'INV-02');
      expect(ledger.invoices[0].runningBalance, 1700.0);

      expect(ledger.invoices[1].invoice.invoiceNo, 'INV-03-BACKDATED');
      expect(ledger.invoices[1].runningBalance, 1200.0);

      expect(ledger.invoices[2].invoice.invoiceNo, 'INV-01');
      expect(ledger.invoices[2].runningBalance, 1000.0);
    });
  });
}
