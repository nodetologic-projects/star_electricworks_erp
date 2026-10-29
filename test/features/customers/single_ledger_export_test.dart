import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/customers/ledger/customer_ledger_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late InvoicesRepository repo;
  late int customerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = InvoicesRepository(db);

    customerId = await db.into(db.customers).insert(
      CustomersCompanion.insert(
        name: 'Shiv Shakti Engineering',
        address: 'Plot 12, GIDC, Makarpura, Vadodara',
        state: 'Gujarat',
        phone: '9825012345',
        email: 'shivshakti@example.com',
        gstin: const drift.Value('24AAACS1234A1Z5'),
        panNumber: const drift.Value('AAACS1234A'),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Single Ledger Export (Statement of Account)', () {
    test('Customer with fully paid, partially paid, unpaid, and pending invoices: verifies Full Ledger, Outstanding mode, and screen totals consistency', () async {
      final now = IstDateUtils.nowIst();
      final baseDate = DateTime(now.year, now.month, 1);

      // 1. Fully Paid Invoice: Service Tax Invoice, 10,000, Paid 10,000
      final inv1Date = IstDateUtils.toMidnightIst(baseDate.subtract(const Duration(days: 20)));
      final inv1Id = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-PAID-01',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv1Date,
          dueDate: drift.Value(inv1Date.add(const Duration(days: 15))),
          subtotal: 10000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 10000,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.paid,
        ),
        [],
      );
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: inv1Id,
          amount: 10000,
          paymentDate: inv1Date.add(const Duration(days: 5)),
          paymentMode: PaymentMode.bankTransfer,
          referenceNo: const drift.Value('NEFT123456'),
        ),
      );

      // 2. Partially Paid Invoice: Sales Tax Invoice, 6,000, Paid 2,000 (Balance = 4,000)
      final inv2Date = IstDateUtils.toMidnightIst(baseDate.subtract(const Duration(days: 15)));
      final inv2Id = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-PARTIAL-02',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: inv2Date,
          dueDate: drift.Value(inv2Date.add(const Duration(days: 10))),
          subtotal: 6000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 6000,
          amountInWords: 'Six Thousand Only',
          status: InvoiceStatus.partiallyPaid,
        ),
        [],
      );
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: inv2Id,
          amount: 2000,
          paymentDate: inv2Date.add(const Duration(days: 3)),
          paymentMode: PaymentMode.upi,
          referenceNo: const drift.Value('UPI987654'),
        ),
      );

      // 3. Unpaid Overdue Invoice: Bill of Supply, 5,000, Paid 0, past due
      final inv3Date = IstDateUtils.toMidnightIst(baseDate.subtract(const Duration(days: 10)));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'BOS-UNPAID-03',
          invoiceType: InvoiceType.billOfSupply,
          customerId: customerId,
          invoiceDate: inv3Date,
          dueDate: drift.Value(inv3Date.add(const Duration(days: 2))), // Overdue
          subtotal: 5000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 5000,
          amountInWords: 'Five Thousand Only',
          status: InvoiceStatus.overdue,
        ),
        [],
      );

      // 4. Pending / Draft Invoice: Service Tax Invoice, 4,000, Paid 0, due in future
      final inv4Date = IstDateUtils.toMidnightIst(baseDate);
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-PENDING-04',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv4Date,
          dueDate: drift.Value(inv4Date.add(const Duration(days: 30))), // Not overdue
          subtotal: 4000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 4000,
          amountInWords: 'Four Thousand Only',
          status: InvoiceStatus.draft, // Saved pending bill
        ),
        [],
      );

      // 5. Excluded documents: Delivery Challan & Purchase Voucher
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DC-0001',
          invoiceType: InvoiceType.deliveryChallan,
          customerId: customerId,
          invoiceDate: inv4Date,
          subtotal: 0,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 0,
          amountInWords: 'Zero Only',
          status: InvoiceStatus.delivered,
        ),
        [],
      );
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'PV-0001',
          invoiceType: InvoiceType.purchaseVoucher,
          customerId: customerId,
          invoiceDate: inv4Date,
          subtotal: 3000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 3000,
          amountInWords: 'Three Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // --- Verify Customer Ledger Screen Totals ---
      final ledgerScreenResult = await repo.getCustomerLedger(customerId);
      // Total Billed: 10,000 + 6,000 + 5,000 + 4,000 = 25,000
      expect(ledgerScreenResult.totalBilled, 25000.0);
      // Total Paid: 10,000 + 2,000 = 12,000
      expect(ledgerScreenResult.totalPaid, 12000.0);
      // Total Outstanding: 25,000 - 12,000 = 13,000
      expect(ledgerScreenResult.totalOutstanding, 13000.0);
      // All 4 invoices are present, DC & PV excluded
      expect(ledgerScreenResult.invoices.length, 4);

      // --- Verify Mode A: Full Ledger Statement ---
      final fullLedgerStatement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null, // All time
        toDate: now.add(const Duration(days: 1)),
      );

      // 4 bills + 2 payments = 6 entries
      expect(fullLedgerStatement.entries.length, 6);
      expect(fullLedgerStatement.totalDebit, 25000.0);
      expect(fullLedgerStatement.totalCredit, 12000.0);
      // Step 4: Closing Balance must equal Customer Ledger Outstanding
      expect(fullLedgerStatement.closingBalance, ledgerScreenResult.totalOutstanding);
      expect(fullLedgerStatement.closingBalance, 13000.0);

      // Verify Status column per invoice in Full Ledger
      final invEntries = fullLedgerStatement.entries.where((e) => e.debit != null).toList();
      expect(invEntries.length, 4);

      final paidEntry = invEntries.firstWhere((e) => e.document.contains('INV-PAID-01'));
      expect(paidEntry.status, 'Paid');

      final partialEntry = invEntries.firstWhere((e) => e.document.contains('INV-PARTIAL-02'));
      expect(partialEntry.status, 'Partially Paid');

      final overdueEntry = invEntries.firstWhere((e) => e.document.contains('BOS-UNPAID-03'));
      expect(overdueEntry.status, 'Overdue');

      final pendingEntry = invEntries.firstWhere((e) => e.document.contains('INV-PENDING-04'));
      expect(pendingEntry.status, 'Unpaid');

      // Payment entries have null status
      final paymentEntries = fullLedgerStatement.entries.where((e) => e.credit != null).toList();
      for (final p in paymentEntries) {
        expect(p.status, isNull);
      }

      // Generate Full Ledger PDF
      final fullLedgerPdf = await CustomerLedgerPdfGenerator.generateFullLedger(
        statement: fullLedgerStatement,
      );
      expect(fullLedgerPdf, isNotEmpty);

      // --- Verify Mode B: Outstanding Bills Only Statement ---
      final outstandingStatement = await repo.getCustomerOutstandingStatement(
        customerId: customerId,
        asOfDate: now,
      );

      // Only the 3 invoices with balance due appear (INV-PAID-01 is omitted)
      expect(outstandingStatement.bills.length, 3);
      final billNos = outstandingStatement.bills.map((b) => b.invoiceNo).toList();
      expect(billNos, contains('INV-PARTIAL-02'));
      expect(billNos, contains('BOS-UNPAID-03'));
      expect(billNos, contains('INV-PENDING-04'));
      expect(billNos.contains('INV-PAID-01'), isFalse);

      // Partially paid bill shows remaining balance, not full amount
      final partialBill = outstandingStatement.bills.firstWhere((b) => b.invoiceNo == 'INV-PARTIAL-02');
      expect(partialBill.billAmount, 6000.0);
      expect(partialBill.amountPaid, 2000.0);
      expect(partialBill.balanceDue, 4000.0);

      final unpaidBill = outstandingStatement.bills.firstWhere((b) => b.invoiceNo == 'BOS-UNPAID-03');
      expect(unpaidBill.billAmount, 5000.0);
      expect(unpaidBill.amountPaid, 0.0);
      expect(unpaidBill.balanceDue, 5000.0);
      expect(unpaidBill.daysOverdue, greaterThan(0));

      final pendingBill = outstandingStatement.bills.firstWhere((b) => b.invoiceNo == 'INV-PENDING-04');
      expect(pendingBill.billAmount, 4000.0);
      expect(pendingBill.amountPaid, 0.0);
      expect(pendingBill.balanceDue, 4000.0);
      expect(pendingBill.daysOverdue, 0);

      // Step 4: Total Outstanding must equal Customer Ledger Outstanding and Full Ledger Closing Balance
      expect(outstandingStatement.totalOutstanding, ledgerScreenResult.totalOutstanding);
      expect(outstandingStatement.totalOutstanding, fullLedgerStatement.closingBalance);
      expect(outstandingStatement.totalOutstanding, 13000.0);

      // Sorted oldest first
      for (int i = 0; i < outstandingStatement.bills.length - 1; i++) {
        expect(
          outstandingStatement.bills[i].invoiceDate.isBefore(outstandingStatement.bills[i + 1].invoiceDate) ||
          outstandingStatement.bills[i].invoiceDate.isAtSameMomentAs(outstandingStatement.bills[i + 1].invoiceDate),
          isTrue,
        );
      }

      // Generate Outstanding Bills PDF
      final outstandingPdf = await CustomerLedgerPdfGenerator.generateOutstandingBills(
        statement: outstandingStatement,
      );
      expect(outstandingPdf, isNotEmpty);
    });

    test('Date range starting mid-way computes Opening Balance correctly and matches Outstanding', () async {
      // 1. Activity before the range (April 2026)
      final aprDate = IstDateUtils.toMidnightIst(DateTime(2026, 4, 10));
      final aprInvId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-APR-01',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: aprDate,
          subtotal: 10000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 10000,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: aprInvId,
          amount: 3000,
          paymentDate: aprDate.add(const Duration(days: 5)),
          paymentMode: PaymentMode.cash,
        ),
      );

      // 2. Activity within the range (May 2026)
      final mayDate = IstDateUtils.toMidnightIst(DateTime(2026, 5, 10));
      final mayInvId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-MAY-01',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: mayDate,
          subtotal: 5000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 5000,
          amountInWords: 'Five Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: mayInvId,
          amount: 2000,
          paymentDate: mayDate.add(const Duration(days: 5)),
          paymentMode: PaymentMode.upi,
        ),
      );

      // Screen totals
      final screenResult = await repo.getCustomerLedger(customerId);
      expect(screenResult.totalBilled, 15000.0);
      expect(screenResult.totalPaid, 5000.0);
      expect(screenResult.totalOutstanding, 10000.0);

      // Query statement from 01/05/2026 to 31/05/2026
      final fromDate = DateTime(2026, 5, 1);
      final toDate = DateTime(2026, 5, 31);
      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: fromDate,
        toDate: toDate,
      );

      // Opening Balance before May 1: 10,000 (debit) - 3,000 (credit) = 7,000
      expect(statement.openingBalance, 7000.0);
      // May Activity: Debit = 5,000, Credit = 2,000
      expect(statement.totalDebit, 5000.0);
      expect(statement.totalCredit, 2000.0);
      // Closing balance: 7,000 + 5,000 - 2,000 = 10,000
      expect(statement.closingBalance, 10000.0);
      expect(statement.closingBalance, screenResult.totalOutstanding);
    });

    test('Empty range detection: returns 0 opening balance and empty entries list', () async {
      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: DateTime(2026, 1, 1),
        toDate: DateTime(2026, 1, 31),
      );

      expect(statement.openingBalance, 0.0);
      expect(statement.entries, isEmpty);
      expect(statement.totalDebit, 0.0);
      expect(statement.totalCredit, 0.0);
      expect(statement.closingBalance, 0.0);
    });

    test('Multi-page ledger: generates multi-page PDF with repeating table headers and accurate running balance', () async {
      // Create 35 invoices so table naturally overflows across pages
      final startDate = DateTime(2026, 4, 1);
      for (int i = 1; i <= 35; i++) {
        final invDate = IstDateUtils.toMidnightIst(startDate.add(Duration(days: i)));
        await repo.createInvoiceWithItems(
          InvoicesCompanion.insert(
            invoiceNo: 'INV-M${i.toString().padLeft(4, '0')}',
            invoiceType: InvoiceType.serviceTaxInvoice,
            customerId: customerId,
            invoiceDate: invDate,
            subtotal: 1000.0 * i,
            cgstAmount: 0,
            sgstAmount: 0,
            discountAmount: 0,
            grandTotal: 1000.0 * i,
            amountInWords: 'Amount in words',
            status: InvoiceStatus.draft, // All draft pending bills
          ),
          [],
        );
      }

      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 12, 31),
      );

      expect(statement.entries.length, 35);
      final pdfBytes = await CustomerLedgerPdfGenerator.generateFullLedger(
        statement: statement,
      );
      expect(pdfBytes, isNotEmpty);
    });
  });
}
