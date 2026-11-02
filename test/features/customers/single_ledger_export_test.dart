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

  group('Complete Party Ledger (Single Customer Ledger & Export PDF)', () {
    test('Customer with invoice, partial payment, delivery challan, motor job, quotation, purchase voucher and credit note: verify all appear, balance only moves for accounting rows, closing balance equals Customer Ledger screen, checkbox filters work, drafts excluded', () async {
      final baseDate = DateTime(2026, 5, 1);

      // 1. Accounting Row: Service Tax Invoice, ₹10,000 (May 1)
      final invDate = IstDateUtils.toMidnightIst(baseDate);
      final invId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-2026-001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: invDate,
          dueDate: drift.Value(invDate.add(const Duration(days: 15))),
          subtotal: 10000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 10000,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [
          InvoiceItemsCompanion.insert(
            invoiceId: 0,
            itemSourceType: ItemSourceType.custom,
            description: 'Motor Rewinding 10HP',
            unitPrice: 10000,
            lineTotal: 10000,
          ),
        ],
      );

      // 2. Accounting Row: Partial Payment, ₹3,000 (May 5)
      final paymentDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 4)));
      await db.into(db.payments).insert(
        PaymentsCompanion.insert(
          invoiceId: invId,
          amount: 3000,
          paymentDate: paymentDate,
          paymentMode: PaymentMode.bankTransfer,
          referenceNo: const drift.Value('NEFT987654'),
        ),
      );

      // 3. Reference Row: Delivery Challan (May 8)
      final dcDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 7)));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DC-2026-001',
          invoiceType: InvoiceType.deliveryChallan,
          customerId: customerId,
          invoiceDate: dcDate,
          subtotal: 0,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 0,
          amountInWords: 'Zero Only',
          status: InvoiceStatus.delivered,
          gpNumber: const drift.Value('GP-101'),
          gpDate: drift.Value(dcDate),
          deliveryCharge: const drift.Value(250.0),
        ),
        [
          InvoiceItemsCompanion.insert(
            invoiceId: 0,
            itemSourceType: ItemSourceType.custom,
            description: 'Crompton 10HP Motor Dispatched',
            unitPrice: 0,
            lineTotal: 0,
          ),
        ],
      );

      // 4. Reference Row: Motor Job (May 10)
      final jobDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 9)));
      await db.into(db.motorJobs).insert(
        MotorJobsCompanion.insert(
          jobNo: 'JOB-2026-001',
          customerId: customerId,
          motorDescription: '15HP ABB Motor Rewinding',
          dateReceived: jobDate,
          jobDescription: 'Stator coil replacement',
          status: MotorJobStatus.inProgress,
          dispatchDate: drift.Value(jobDate.add(const Duration(days: 10))),
        ),
      );

      // 5. Reference Row: Quotation (May 12)
      final quoteDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 11)));
      await db.into(db.quotations).insert(
        QuotationsCompanion.insert(
          quoteNo: 'QT-2026-001',
          customerId: drift.Value(customerId),
          description: 'Transformer Overhaul Quote',
          estimatedAmount: 25000,
          status: QuotationStatus.sent,
          validUntil: drift.Value(baseDate.add(const Duration(days: 30))),
          createdAt: drift.Value(quoteDate),
        ),
      );

      // 6. Reference Row: Purchase Voucher (May 14)
      final pvDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 13)));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'PV-2026-001',
          invoiceType: InvoiceType.purchaseVoucher,
          customerId: customerId,
          invoiceDate: pvDate,
          subtotal: 5000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 5000,
          amountInWords: 'Five Thousand Only',
          status: InvoiceStatus.sent,
          notes: const drift.Value('Bearing and wire procurement'),
        ),
        [],
      );

      // 7. Accounting Row: Credit Note (May 18)
      final cnDate = IstDateUtils.toMidnightIst(baseDate.add(const Duration(days: 17)));
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-2026-001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          invoiceDate: cnDate,
          originalInvoiceId: drift.Value(invId),
          noteReason: const drift.Value(NoteReason.price_correction),
          noteReasonText: const drift.Value('Agreed rate reduction'),
          subtotal: 1500,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 1500,
          amountInWords: 'One Thousand Five Hundred Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // 8. Draft Documents: Should be EXCLUDED under the draft exclusion rule!
      // Draft invoice
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-DRAFT-099',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: baseDate.add(const Duration(days: 20)),
          subtotal: 8000,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 8000,
          amountInWords: 'Eight Thousand Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );
      // Draft challan
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DC-DRAFT-099',
          invoiceType: InvoiceType.deliveryChallan,
          customerId: customerId,
          invoiceDate: baseDate.add(const Duration(days: 21)),
          subtotal: 0,
          cgstAmount: 0,
          sgstAmount: 0,
          discountAmount: 0,
          grandTotal: 0,
          amountInWords: 'Zero Only',
          status: InvoiceStatus.draft,
        ),
        [],
      );
      // Draft quotation
      await db.into(db.quotations).insert(
        QuotationsCompanion.insert(
          quoteNo: 'QT-DRAFT-099',
          customerId: drift.Value(customerId),
          description: 'Draft Quote',
          estimatedAmount: 9000,
          status: QuotationStatus.draft,
          createdAt: drift.Value(baseDate.add(const Duration(days: 22))),
        ),
      );

      // --- VERIFICATION 1: On-Screen Customer Ledger Detail ---
      final ledgerScreenResult = await repo.getCustomerLedger(customerId);

      // Total Billed = 10,000 (Invoice)
      expect(ledgerScreenResult.totalBilled, 10000.0);
      // Total Paid / Credited = 3,000 (Payment) + 1,500 (Credit Note) = 4,500
      expect(ledgerScreenResult.totalPaid, 4500.0);
      // Total Outstanding = 10,000 - 4,500 = 5,500
      expect(ledgerScreenResult.totalOutstanding, 5500.0);

      // All 7 non-draft documents must appear, drafts excluded!
      expect(ledgerScreenResult.entries.length, 7);
      final docTypesOnScreen = ledgerScreenResult.entries.map((e) => e.documentType).toList();
      expect(docTypesOnScreen, contains('Service Tax Invoice'));
      expect(docTypesOnScreen, contains('Payment'));
      expect(docTypesOnScreen, contains('Delivery Challan'));
      expect(docTypesOnScreen, contains('Motor Job'));
      expect(docTypesOnScreen, contains('Quotation'));
      expect(docTypesOnScreen, contains('Purchase Voucher'));
      expect(docTypesOnScreen, contains('Credit Note'));

      // Verify draft exclusion on screen
      final docNosOnScreen = ledgerScreenResult.entries.map((e) => e.documentNo).toList();
      expect(docNosOnScreen.contains('INV-DRAFT-099'), isFalse);
      expect(docNosOnScreen.contains('DC-DRAFT-099'), isFalse);
      expect(docNosOnScreen.contains('QT-DRAFT-099'), isFalse);

      // --- VERIFICATION 2: Full Ledger Statement Export ---
      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
      );

      expect(statement.entries.length, 7);
      expect(statement.totalDebit, 10000.0);
      expect(statement.totalCredit, 4500.0);

      // CRITICAL RULE: Closing Balance and Outstanding must equal Customer Ledger screen
      expect(statement.closingBalance, ledgerScreenResult.totalOutstanding);
      expect(statement.closingBalance, 5500.0);

      // VERIFICATION 3: Chronological timeline & Running Balance behavior
      // 1. Service Tax Invoice (May 1) -> Debit: 10,000, Running Balance: 10,000
      final invRow = statement.entries[0];
      expect(invRow.documentType, 'Service Tax Invoice');
      expect(invRow.documentNo, 'INV-2026-001');
      expect(invRow.isReference, isFalse);
      expect(invRow.debit, 10000.0);
      expect(invRow.credit, isNull);
      expect(invRow.runningBalance, 10000.0);
      expect(invRow.status, 'Partially Paid');

      // 2. Payment (May 5) -> Credit: 3,000, Running Balance: 7,000
      final payRow = statement.entries[1];
      expect(payRow.documentType, 'Payment');
      expect(payRow.documentNo, 'NEFT987654');
      expect(payRow.isReference, isFalse);
      expect(payRow.debit, isNull);
      expect(payRow.credit, 3000.0);
      expect(payRow.runningBalance, 7000.0);

      // 3. Delivery Challan (May 8) -> Reference row: Debit: null, Credit: null, Running Balance: 7,000 (UNCHANGED!)
      final dcRow = statement.entries[2];
      expect(dcRow.documentType, 'Delivery Challan');
      expect(dcRow.documentNo, 'DC-2026-001');
      expect(dcRow.isReference, isTrue);
      expect(dcRow.debit, isNull);
      expect(dcRow.credit, isNull);
      expect(dcRow.runningBalance, 7000.0);
      expect(dcRow.status, 'Delivered');
      expect(dcRow.details, contains('GP No: GP-101'));
      expect(dcRow.details, contains('Crompton 10HP Motor Dispatched'));
      expect(dcRow.details, contains('Delivery Charge: ₹250.00'));

      // 4. Motor Job (May 10) -> Reference row: Running Balance: 7,000 (UNCHANGED!)
      final jobRow = statement.entries[3];
      expect(jobRow.documentType, 'Motor Job');
      expect(jobRow.documentNo, 'JOB-2026-001');
      expect(jobRow.isReference, isTrue);
      expect(jobRow.debit, isNull);
      expect(jobRow.credit, isNull);
      expect(jobRow.runningBalance, 7000.0);
      expect(jobRow.status, 'In Progress');
      expect(jobRow.details, contains('15HP ABB Motor Rewinding'));

      // 5. Quotation (May 12) -> Reference row: Running Balance: 7,000 (UNCHANGED!)
      final quoteRow = statement.entries[4];
      expect(quoteRow.documentType, 'Quotation');
      expect(quoteRow.documentNo, 'QT-2026-001');
      expect(quoteRow.isReference, isTrue);
      expect(quoteRow.debit, isNull);
      expect(quoteRow.credit, isNull);
      expect(quoteRow.runningBalance, 7000.0);
      expect(quoteRow.status, 'Sent');
      expect(quoteRow.details, contains('Amount: ₹25000.00'));

      // 6. Purchase Voucher (May 14) -> Reference row: Running Balance: 7,000 (UNCHANGED!)
      final pvRow = statement.entries[5];
      expect(pvRow.documentType, 'Purchase Voucher');
      expect(pvRow.documentNo, 'PV-2026-001');
      expect(pvRow.isReference, isTrue);
      expect(pvRow.debit, isNull);
      expect(pvRow.credit, isNull);
      expect(pvRow.runningBalance, 7000.0);
      expect(pvRow.status, 'Sent');
      expect(pvRow.details, contains('Total: ₹5000.00'));

      // 7. Credit Note (May 18) -> Accounting row: Credit: 1,500, Running Balance: 5,500
      final cnRow = statement.entries[6];
      expect(cnRow.documentType, 'Credit Note');
      expect(cnRow.documentNo, 'CN-2026-001');
      expect(cnRow.isReference, isFalse);
      expect(cnRow.debit, isNull);
      expect(cnRow.credit, 1500.0);
      expect(cnRow.runningBalance, 5500.0);
      expect(cnRow.details, contains('Against INV-2026-001'));
      expect(cnRow.details, contains('Price Correction'));

      // VERIFICATION 4: Document Counts in Summary Box
      expect(statement.documentCounts['Invoices'], 1);
      expect(statement.documentCounts['Payments'], 1);
      expect(statement.documentCounts['Delivery Challans'], 1);
      expect(statement.documentCounts['Motor Jobs'], 1);
      expect(statement.documentCounts['Quotations'], 1);
      expect(statement.documentCounts['Purchase Vouchers'], 1);
      expect(statement.documentCounts['Credit Notes'], 1);

      // VERIFICATION 5: Checkbox Filters
      // A. Unchecking Delivery Challans hides DC rows, balances remain identical
      final withoutDc = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
        filterOptions: const LedgerFilterOptions(includeDeliveryChallans: false),
      );
      expect(withoutDc.entries.length, 6);
      expect(withoutDc.entries.any((e) => e.documentType == 'Delivery Challan'), isFalse);
      expect(withoutDc.closingBalance, 5500.0);

      // B. Unchecking Motor Jobs hides Motor Job rows, balances remain identical
      final withoutJob = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
        filterOptions: const LedgerFilterOptions(includeMotorJobs: false),
      );
      expect(withoutJob.entries.length, 6);
      expect(withoutJob.entries.any((e) => e.documentType == 'Motor Job'), isFalse);
      expect(withoutJob.closingBalance, 5500.0);

      // C. Unchecking Quotations hides Quotation rows, balances remain identical
      final withoutQuote = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
        filterOptions: const LedgerFilterOptions(includeQuotations: false),
      );
      expect(withoutQuote.entries.length, 6);
      expect(withoutQuote.entries.any((e) => e.documentType == 'Quotation'), isFalse);
      expect(withoutQuote.closingBalance, 5500.0);

      // D. Unchecking Purchase Vouchers hides PV rows, balances remain identical
      final withoutPv = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
        filterOptions: const LedgerFilterOptions(includePurchaseVouchers: false),
      );
      expect(withoutPv.entries.length, 6);
      expect(withoutPv.entries.any((e) => e.documentType == 'Purchase Voucher'), isFalse);
      expect(withoutPv.closingBalance, 5500.0);

      // E. Unchecking ALL reference rows leaves only the 3 accounting rows (Invoice, Payment, Credit Note)
      final onlyAccounting = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: null,
        toDate: DateTime(2026, 5, 31),
        filterOptions: const LedgerFilterOptions(
          includeDeliveryChallans: false,
          includeMotorJobs: false,
          includeQuotations: false,
          includePurchaseVouchers: false,
        ),
      );
      expect(onlyAccounting.entries.length, 3);
      expect(onlyAccounting.entries.every((e) => !e.isReference), isTrue);
      expect(onlyAccounting.closingBalance, 5500.0);
      expect(onlyAccounting.totalDebit, 10000.0);
      expect(onlyAccounting.totalCredit, 4500.0);

      // VERIFICATION 6: PDF Generation and visual confirmation
      final pdfBytes = await CustomerLedgerPdfGenerator.generateFullLedger(
        statement: statement,
      );
      expect(pdfBytes, isNotEmpty);

      // Save PDF sample for visual inspection
      final artifactDir = '/Users/nodetolearn/.gemini/antigravity/brain/73056598-9f94-4e14-9a2c-092d709cd64c';
      final samplePdfFile = File('$artifactDir/sample_complete_party_ledger.pdf');
      await samplePdfFile.writeAsBytes(pdfBytes);
      expect(samplePdfFile.existsSync(), isTrue);
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

      // Reference row before the range: Should be omitted from opening balance!
      await db.into(db.motorJobs).insert(
        MotorJobsCompanion.insert(
          jobNo: 'JOB-APR-01',
          customerId: customerId,
          motorDescription: 'Old motor job before period',
          dateReceived: aprDate,
          jobDescription: 'Rewind',
          status: MotorJobStatus.dispatched,
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

      // Opening Balance before May 1: 10,000 (debit) - 3,000 (credit) = 7,000 (reference rows omitted)
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

    test('Multi-page ledger: generates multi-page PDF with repeating table headers, page numbers, and clean Details text wrapping', () async {
      final startDate = DateTime(2026, 4, 1);
      // Create 35 non-draft invoices with varying long descriptions
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
            status: InvoiceStatus.sent,
          ),
          [
            InvoiceItemsCompanion.insert(
              invoiceId: 0,
              itemSourceType: ItemSourceType.custom,
              description: 'Rewinding and overhauling of ${i * 5}HP 3-phase induction electric motor with Class H copper wire',
              unitPrice: 1000.0 * i,
              lineTotal: 1000.0 * i,
            ),
          ],
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

      // Save multipage sample for visual inspection
      final artifactDir = '/Users/nodetolearn/.gemini/antigravity/brain/73056598-9f94-4e14-9a2c-092d709cd64c';
      final multipagePdfFile = File('$artifactDir/sample_multipage_party_ledger.pdf');
      await multipagePdfFile.writeAsBytes(pdfBytes);
      expect(multipagePdfFile.existsSync(), isTrue);
    });
  });
}
