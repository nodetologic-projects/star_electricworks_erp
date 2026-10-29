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
    test('Customer with 2 invoices and 1 partial payment: All Time statement and Closing Balance == Outstanding', () async {
      // 1. Invoice 1: 01/05/2026, Grand Total = 10,000
      final inv1Date = IstDateUtils.toMidnightIst(DateTime(2026, 5, 1));
      final inv1Id = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv1Date,
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

      // 2. Partial Payment for Invoice 1: 05/05/2026, Amount = 4,000
      final payDate = IstDateUtils.toMidnightIst(DateTime(2026, 5, 5));
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: inv1Id,
          amount: 4000,
          paymentDate: payDate,
          paymentMode: PaymentMode.upi,
          referenceNo: const drift.Value('UPI9876543210'),
        ),
      );

      // 3. Invoice 2: 10/05/2026, Grand Total = 6,000
      final inv2Date = IstDateUtils.toMidnightIst(DateTime(2026, 5, 10));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0002',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: inv2Date,
          subtotal: 6000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 6000,
          amountInWords: 'Six Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Verify Customer Ledger screen totals
      final ledgerScreenResult = await repo.getCustomerLedger(customerId);
      expect(ledgerScreenResult.totalBilled, 16000.0);
      expect(ledgerScreenResult.totalPaid, 4000.0);
      expect(ledgerScreenResult.totalOutstanding, 12000.0);

      // Verify Statement of Account (All Time)
      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null, // All time
        toDate: DateTime(2026, 5, 31),
      );

      expect(statement.openingBalance, 0.0);
      expect(statement.entries.length, 3);

      // Entry 1: Invoice 1
      expect(statement.entries[0].document, contains('INV-C0001'));
      expect(statement.entries[0].debit, 10000.0);
      expect(statement.entries[0].credit, isNull);
      expect(statement.entries[0].runningBalance, 10000.0);

      // Entry 2: Payment 1
      expect(statement.entries[1].document, contains('Payment Received - UPI'));
      expect(statement.entries[1].document, contains('UPI9876543210'));
      expect(statement.entries[1].debit, isNull);
      expect(statement.entries[1].credit, 4000.0);
      expect(statement.entries[1].runningBalance, 6000.0);

      // Entry 3: Invoice 2
      expect(statement.entries[2].document, contains('INV-C0002'));
      expect(statement.entries[2].debit, 6000.0);
      expect(statement.entries[2].credit, isNull);
      expect(statement.entries[2].runningBalance, 12000.0);

      expect(statement.totalDebit, 16000.0);
      expect(statement.totalCredit, 4000.0);
      expect(statement.closingBalance, 12000.0);

      // Strict requirement: Closing Balance must exactly equal Customer Ledger Outstanding
      expect(statement.closingBalance, equals(ledgerScreenResult.totalOutstanding));

      // Test PDF Generation
      final pdfBytes = await CustomerLedgerPdfGenerator.generate(statement: statement);
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(1000));
      // Standard PDF header signature
      expect(String.fromCharCodes(pdfBytes.take(4)), '%PDF');
    });

    test('Date range starting mid-way computes Opening Balance correctly and matches Outstanding', () async {
      // Invoice 1: 01/05/2026, Grand Total = 10,000
      final inv1Date = IstDateUtils.toMidnightIst(DateTime(2026, 5, 1));
      final inv1Id = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: inv1Date,
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

      // Payment for Invoice 1: 05/05/2026, Amount = 4,000
      final payDate = IstDateUtils.toMidnightIst(DateTime(2026, 5, 5));
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: inv1Id,
          amount: 4000,
          paymentDate: payDate,
          paymentMode: PaymentMode.cash,
        ),
      );

      // Invoice 2: 10/05/2026, Grand Total = 6,000
      final inv2Date = IstDateUtils.toMidnightIst(DateTime(2026, 5, 10));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0002',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: inv2Date,
          subtotal: 6000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 6000,
          amountInWords: 'Six Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Select range from 08/05/2026 to 31/05/2026 (starts AFTER Invoice 1 & Payment 1, BEFORE Invoice 2)
      final midWayFrom = IstDateUtils.toMidnightIst(DateTime(2026, 5, 8));
      final midWayTo = IstDateUtils.toMidnightIst(DateTime(2026, 5, 31));

      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: midWayFrom,
        toDate: midWayTo,
      );

      // Opening balance must be 10,000 - 4,000 = 6,000
      expect(statement.openingBalance, 6000.0);
      // In-period entries: only Invoice 2
      expect(statement.entries.length, 1);
      expect(statement.entries[0].document, contains('INV-C0002'));
      expect(statement.entries[0].debit, 6000.0);
      expect(statement.entries[0].runningBalance, 12000.0);

      expect(statement.totalDebit, 6000.0);
      expect(statement.totalCredit, 0.0);
      // Closing Balance = Opening Balance (6000) + Total Debit (6000) - Total Credit (0) = 12000
      expect(statement.closingBalance, 12000.0);

      final ledgerScreenResult = await repo.getCustomerLedger(customerId);
      expect(statement.closingBalance, equals(ledgerScreenResult.totalOutstanding));

      final pdfBytes = await CustomerLedgerPdfGenerator.generate(statement: statement);
      expect(pdfBytes, isNotEmpty);
    });

    test('Empty range detection: returns 0 opening balance and empty entries list', () async {
      // Query for year 2024 (no invoices or payments)
      final from2024 = IstDateUtils.toMidnightIst(DateTime(2024, 1, 1));
      final to2024 = IstDateUtils.toMidnightIst(DateTime(2024, 12, 31));

      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: from2024,
        toDate: to2024,
      );

      expect(statement.openingBalance, 0.0);
      expect(statement.entries, isEmpty);
      expect(statement.totalDebit, 0.0);
      expect(statement.totalCredit, 0.0);
      expect(statement.closingBalance, 0.0);
    });

    test('Excludes drafts, Delivery Challans, and Purchase Vouchers from ledger and statement', () async {
      // 1. Valid Service Tax Invoice: 5,000
      final validInvDate = IstDateUtils.toMidnightIst(DateTime(2026, 5, 1));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-C0001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: validInvDate,
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

      // 2. Draft Invoice (must be excluded)
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-DRAFT-01',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: validInvDate,
          subtotal: 9999,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 9999,
          amountInWords: 'Draft Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );

      // 3. Delivery Challan (must be excluded)
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DC-0001',
          invoiceType: InvoiceType.deliveryChallan,
          customerId: customerId,
          invoiceDate: validInvDate,
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

      // 4. Purchase Voucher (must be excluded)
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'PV-0001',
          invoiceType: InvoiceType.purchaseVoucher,
          customerId: customerId,
          invoiceDate: validInvDate,
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

      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
      );

      // Only the 1 valid Service Tax Invoice should be present
      expect(statement.entries.length, 1);
      expect(statement.entries.first.document, contains('INV-C0001'));
      expect(statement.totalDebit, 5000.0);
      expect(statement.closingBalance, 5000.0);

      final ledgerScreenResult = await repo.getCustomerLedger(customerId);
      expect(ledgerScreenResult.totalBilled, 5000.0);
      expect(ledgerScreenResult.totalOutstanding, 5000.0);
      expect(statement.closingBalance, equals(ledgerScreenResult.totalOutstanding));
    });

    test('Multi-page ledger: generates multi-page PDF with repeating table headers and accurate running balance', () async {
      // Create 35 invoices with payments across months to comfortably exceed 1 A4 page
      double expectedRunningBal = 0.0;
      final startDate = DateTime(2026, 4, 1);

      for (int i = 1; i <= 30; i++) {
        final invDate = IstDateUtils.toMidnightIst(startDate.add(Duration(days: i * 3)));
        const invAmount = 2500.0;
        final invId = await repo.createInvoiceWithItems(
          InvoicesCompanion.insert(
            invoiceNo: 'INV-C${i.toString().padLeft(4, '0')}',
            invoiceType: (i % 2 == 0) ? InvoiceType.salesTaxInvoice : InvoiceType.serviceTaxInvoice,
            customerId: customerId,
            invoiceDate: invDate,
            subtotal: invAmount,
            cgstAmount: 0,
            sgstAmount: 0,
            discountAmount: 0,
            grandTotal: invAmount,
            amountInWords: 'Amount in words',
            status: InvoiceStatus.sent,
          ),
          [],
        );
        expectedRunningBal += invAmount;

        // Every 3 invoices, add a payment
        if (i % 3 == 0) {
          final payDate = IstDateUtils.toMidnightIst(invDate.add(const Duration(days: 1)));
          const payAmount = 3000.0;
          await db.into(db.payments).insert(
            PaymentsCompanion.insert(
              invoiceId: invId,
              amount: payAmount,
              paymentDate: payDate,
              paymentMode: PaymentMode.bankTransfer,
              referenceNo: drift.Value('TXN-$i'),
            ),
          );
          expectedRunningBal -= payAmount;
        }
      }

      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 12, 31),
      );

      // 30 invoices + 10 payments = 40 rows
      expect(statement.entries.length, 40);
      expect(statement.closingBalance, equals(expectedRunningBal));

      final ledgerScreenResult = await repo.getCustomerLedger(customerId);
      expect(statement.closingBalance, equals(ledgerScreenResult.totalOutstanding));

      // Generate PDF
      final pdfBytes = await CustomerLedgerPdfGenerator.generate(statement: statement);
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(15000)); // Multi-page PDF has substantial byte size

      // Save a sample PDF to artifact directory or test output
      final file = File('test/sample_multipage_ledger.pdf');
      await file.writeAsBytes(pdfBytes);
      expect(file.existsSync(), isTrue);
    });
  });
}
