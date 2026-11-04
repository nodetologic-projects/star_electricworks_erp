import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';

void main() {
  late AppDatabase db;
  late InvoicesRepository invoicesRepo;
  late CustomersRepository customersRepo;
  late int customerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    invoicesRepo = InvoicesRepository(db);
    customersRepo = CustomersRepository(db);

    customerId = await customersRepo.insertCustomer(
      CustomersCompanion.insert(
        name: 'Verification Customer',
        phone: '9876543210',
        email: 'verify@example.com',
        address: '123 GIDC, Ahmedabad',
        state: 'Gujarat',
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('v1.0.64 Bugfix End-to-End Verification Tests', () {
    test('1. Create an invoice, record a full payment -> badge changes to Paid immediately, balance due 0.00', () async {
      final now = IstDateUtils.nowIst();
      final invId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-TEST-001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
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

      // Initially Pending (draft)
      var details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      expect(details.computedStatus, InvoiceStatus.draft);
      expect(details.balanceDue, 5900.0);

      // Record full payment
      await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 5900.0,
          paymentMode: PaymentMode.cash,
          paymentDate: now,
        ),
      );

      // Invoice status recomputed and updated in DB
      details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      final storedInv = await invoicesRepo.getInvoiceById(invId);

      expect(details.computedStatus, InvoiceStatus.paid);
      expect(details.balanceDue, 0.0);
      expect(storedInv.status, InvoiceStatus.paid);

      // Dashboard stats
      final stats = await invoicesRepo.getDashboardStats();
      expect(stats['pendingCount'], 0);
      expect(stats['pendingAmount'], 0.0);
    });

    test('2. Record a partial payment -> Partially Paid with right balance; then pay the rest -> Paid', () async {
      final now = IstDateUtils.nowIst();
      final invId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-TEST-002',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 10000,
          cgstAmount: 900,
          sgstAmount: 900,
          discountAmount: 0,
          grandTotal: 11800,
          amountInWords: 'Eleven Thousand Eight Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Partial payment 4000
      final p1 = await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 4000.0,
          paymentMode: PaymentMode.bankTransfer,
          paymentDate: now,
        ),
      );

      var details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      var storedInv = await invoicesRepo.getInvoiceById(invId);
      expect(details.computedStatus, InvoiceStatus.partiallyPaid);
      expect(details.balanceDue, 7800.0);
      expect(storedInv.status, InvoiceStatus.partiallyPaid);

      // Pay the rest (7800)
      await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 7800.0,
          paymentMode: PaymentMode.upi,
          paymentDate: now,
        ),
      );

      details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      storedInv = await invoicesRepo.getInvoiceById(invId);
      expect(details.computedStatus, InvoiceStatus.paid);
      expect(details.balanceDue, 0.0);
      expect(storedInv.status, InvoiceStatus.paid);

      // Delete payment p1 -> reverts to Partially Paid (7800 paid of 11800)
      await invoicesRepo.deletePayment(p1);
      details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      storedInv = await invoicesRepo.getInvoiceById(invId);
      expect(details.computedStatus, InvoiceStatus.partiallyPaid);
      expect(details.balanceDue, 4000.0);
      expect(storedInv.status, InvoiceStatus.partiallyPaid);
    });

    test('3. Invoice with Rounded Off and a discount, paid exactly -> Paid (no 0.01 leftover)', () async {
      final now = IstDateUtils.nowIst();
      // Grand total 3539.999999 or float rounded to 3540.00
      final invId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-TEST-003',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 3000,
          cgstAmount: 270,
          sgstAmount: 270,
          discountAmount: 100,
          grandTotal: 3440.01,
          amountInWords: 'Three Thousand Four Hundred Forty and One Paisa Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 3440.01,
          paymentMode: PaymentMode.cheque,
          paymentDate: now,
        ),
      );

      final details = await invoicesRepo.getInvoiceBalanceDetails(invId);
      final storedInv = await invoicesRepo.getInvoiceById(invId);

      expect(details.computedStatus, InvoiceStatus.paid);
      expect(details.balanceDue, 0.0);
      expect(storedInv.status, InvoiceStatus.paid);
    });

    test('4. Create a credit note and a debit note: pick an invoice from eligible picker, save, confirm original balance/status updates', () async {
      final now = IstDateUtils.nowIst();
      final origInvId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-ORIG-001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 10000,
          cgstAmount: 900,
          sgstAmount: 900,
          discountAmount: 0,
          grandTotal: 11800,
          amountInWords: 'Eleven Thousand Eight Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Verify picker returns original invoice
      final eligible = await invoicesRepo.getEligibleOriginalInvoices(customerId);
      expect(eligible.length, 1);
      expect(eligible.first.invoice.id, origInvId);
      expect(eligible.first.invoice.invoiceNo, 'INV-ORIG-001');
      expect(eligible.first.balanceDue, 11800.0);

      // Create Credit Note of 1800 against original
      await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-TEST-001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvId),
          invoiceDate: now,
          subtotal: 1525.42,
          cgstAmount: 137.29,
          sgstAmount: 137.29,
          discountAmount: 0,
          grandTotal: 1800,
          amountInWords: 'One Thousand Eight Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Original invoice status & balance updated!
      var origDetails = await invoicesRepo.getInvoiceBalanceDetails(origInvId);
      var origStored = await invoicesRepo.getInvoiceById(origInvId);
      expect(origDetails.balanceDue, 10000.0);
      expect(origDetails.computedStatus, InvoiceStatus.partiallyPaid);
      expect(origStored.status, InvoiceStatus.partiallyPaid);

      // Create Debit Note of 500 against original
      await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DN-TEST-001',
          invoiceType: InvoiceType.debit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvId),
          invoiceDate: now,
          subtotal: 423.73,
          cgstAmount: 38.14,
          sgstAmount: 38.14,
          discountAmount: 0,
          grandTotal: 500,
          amountInWords: 'Five Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Original balance updated to 10000 + 500 = 10500
      origDetails = await invoicesRepo.getInvoiceBalanceDetails(origInvId);
      expect(origDetails.balanceDue, 10500.0);

      // Pay remaining 10500
      await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: origInvId,
          amount: 10500.0,
          paymentMode: PaymentMode.bankTransfer,
          paymentDate: now,
        ),
      );

      origDetails = await invoicesRepo.getInvoiceBalanceDetails(origInvId);
      origStored = await invoicesRepo.getInvoiceById(origInvId);
      expect(origDetails.balanceDue, 0.0);
      expect(origDetails.computedStatus, InvoiceStatus.paid);
      expect(origStored.status, InvoiceStatus.paid);
    });

    test('5. Customer Ledger closing balance still equals the outstanding shown on Customer Ledger screen', () async {
      final now = IstDateUtils.nowIst();
      final invId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-LEDGER-001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 10000,
          cgstAmount: 900,
          sgstAmount: 900,
          discountAmount: 0,
          grandTotal: 11800,
          amountInWords: 'Eleven Thousand Eight Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Partial payment 3000
      await invoicesRepo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 3000.0,
          paymentMode: PaymentMode.cash,
          paymentDate: now,
        ),
      );

      // Credit Note 1800
      await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-LEDGER-001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(invId),
          invoiceDate: now,
          subtotal: 1525.42,
          cgstAmount: 137.29,
          sgstAmount: 137.29,
          discountAmount: 0,
          grandTotal: 1800,
          amountInWords: 'One Thousand Eight Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Add a Delivery Challan (reference row: 0 balance impact)
      await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DC-LEDGER-001',
          invoiceType: InvoiceType.deliveryChallan,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 5000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 5000,
          amountInWords: 'Five Thousand Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Check Customer Ledger
      final ledgerResult = await invoicesRepo.getCustomerLedger(customerId);
      final statement = await invoicesRepo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: now.add(const Duration(days: 30)),
      );

      final outstandingRows = await invoicesRepo.getOutstandingSummary();
      final customerOutstanding = outstandingRows.firstWhere((r) => r.customer.id == customerId);

      // Outstanding must be: 11800 (invoice) - 1800 (credit note) - 3000 (payment) = 7000
      expect(ledgerResult.totalOutstanding, 7000.0);
      expect(statement.closingBalance, 7000.0);
      expect(customerOutstanding.totalOutstanding, 7000.0);
      expect(ledgerResult.totalOutstanding, equals(customerOutstanding.totalOutstanding));
      expect(statement.closingBalance, equals(customerOutstanding.totalOutstanding));
    });

    test('6. Startup migration pass recomputes and corrects stuck Pending invoices', () async {
      final now = IstDateUtils.nowIst();
      // Simulate an invoice created in previous version that was paid in full but stuck in draft
      final invId = await invoicesRepo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-STUCK-001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: now,
          subtotal: 4000,
          cgstAmount: 360,
          sgstAmount: 360,
          discountAmount: 0,
          grandTotal: 4720,
          amountInWords: 'Four Thousand Seven Hundred Twenty Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // Insert payment directly without status update (simulating old bug)
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 4720.0,
          paymentMode: PaymentMode.cash,
          paymentDate: now,
        ),
      );

      // Force status back to draft to simulate stuck invoice
      await db.update(db.invoices).replace(
        (await invoicesRepo.getInvoiceById(invId)).copyWith(status: InvoiceStatus.draft),
      );

      var invBefore = await invoicesRepo.getInvoiceById(invId);
      expect(invBefore.status, InvoiceStatus.draft); // stuck on draft!

      // Run startup migration pass
      final correctedCount = await invoicesRepo.recomputeAllInvoiceStatuses();
      expect(correctedCount, greaterThanOrEqualTo(1));

      var invAfter = await invoicesRepo.getInvoiceById(invId);
      expect(invAfter.status, InvoiceStatus.paid); // corrected to paid!
    });
  });
}
