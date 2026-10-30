import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/core/tax_calculator.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Credit & Debit Notes - Tax Calculator', () {
    test('Calculates CGST + SGST correctly for Credit Note and Debit Note', () {
      final cnResult = TaxCalculator.calculate(
        invoiceType: InvoiceType.credit_note,
        items: [
          InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0),
        ],
        taxMode: TaxMode.cgst_sgst,
      );

      expect(cnResult.subtotal, 1000.0);
      expect(cnResult.cgstAmount, 90.0);
      expect(cnResult.sgstAmount, 90.0);
      expect(cnResult.igstAmount, 0.0);
      expect(cnResult.grandTotal, 1180.0);

      final dnResult = TaxCalculator.calculate(
        invoiceType: InvoiceType.debit_note,
        items: [
          InvoiceLineItemInput(lineTotal: 2000.0, gstRate: 18.0),
        ],
        taxMode: TaxMode.cgst_sgst,
      );

      expect(dnResult.subtotal, 2000.0);
      expect(dnResult.cgstAmount, 180.0);
      expect(dnResult.sgstAmount, 180.0);
      expect(dnResult.igstAmount, 0.0);
      expect(dnResult.grandTotal, 2360.0);
    });

    test('Calculates IGST correctly for Credit Note and Debit Note', () {
      final cnResult = TaxCalculator.calculate(
        invoiceType: InvoiceType.credit_note,
        items: [
          InvoiceLineItemInput(lineTotal: 5000.0, gstRate: 18.0),
        ],
        taxMode: TaxMode.igst_only,
      );

      expect(cnResult.subtotal, 5000.0);
      expect(cnResult.cgstAmount, 0.0);
      expect(cnResult.sgstAmount, 0.0);
      expect(cnResult.igstAmount, 900.0);
      expect(cnResult.grandTotal, 5900.0);

      final dnResult = TaxCalculator.calculate(
        invoiceType: InvoiceType.debit_note,
        items: [
          InvoiceLineItemInput(lineTotal: 1500.0, gstRate: 12.0),
        ],
        taxMode: TaxMode.igst_only,
      );

      expect(dnResult.subtotal, 1500.0);
      expect(dnResult.cgstAmount, 0.0);
      expect(dnResult.sgstAmount, 0.0);
      expect(dnResult.igstAmount, 180.0);
      expect(dnResult.grandTotal, 1680.0);
    });

    test('Skips tax for note against Bill of Supply', () {
      final cnResult = TaxCalculator.calculate(
        invoiceType: InvoiceType.credit_note,
        items: [
          InvoiceLineItemInput(lineTotal: 3000.0, gstRate: 18.0),
        ],
        isOriginalBillOfSupply: true,
      );

      expect(cnResult.subtotal, 3000.0);
      expect(cnResult.cgstAmount, 0.0);
      expect(cnResult.sgstAmount, 0.0);
      expect(cnResult.igstAmount, 0.0);
      expect(cnResult.grandTotal, 3000.0);
    });
  });

  group('Credit & Debit Notes - Numbering', () {
    late AppDatabase db;
    late InvoicesRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = InvoicesRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Generates independent sequence numbers for CN and DN per Financial Year', () async {
      final dateFY25 = DateTime(2025, 6, 15);
      final dateFY26 = DateTime(2026, 6, 15);

      final nextCN1 = await repo.getNextInvoiceNumber(InvoiceType.credit_note, dateFY25);
      final nextDN1 = await repo.getNextInvoiceNumber(InvoiceType.debit_note, dateFY25);

      expect(nextCN1.startsWith('CN-'), isTrue);
      expect(nextDN1.startsWith('DN-'), isTrue);

      final nextCN_FY26 = await repo.getNextInvoiceNumber(InvoiceType.credit_note, dateFY26);
      expect(nextCN_FY26.startsWith('CN-'), isTrue);
      expect(nextCN_FY26, isNot(equals(nextCN1)));
    });
  });

  group('Credit & Debit Notes - Database, Balance & Ledger', () {
    late AppDatabase db;
    late InvoicesRepository repo;
    late CustomersRepository custRepo;
    late int customerId;
    late int copperStockId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = InvoicesRepository(db);
      custRepo = CustomersRepository(db);

      customerId = await custRepo.insertCustomer(
        CustomersCompanion.insert(
          name: 'Apex Motors Ltd',
          address: '42 Industrial Area, Vadodara',
          state: 'Gujarat',
          phone: '9876543210',
          email: 'apex@example.com',
          gstin: const drift.Value('24AAACA1234A1Z1'),
        ),
      );

      copperStockId = await db.into(db.copperStock).insert(
        CopperStockCompanion.insert(
          copperType: CopperType.newCopper,
          description: 'Enamelled Copper Wire 22 SWG',
          weightKg: 100.0,
          pricePerKg: 850.0,
          stockQtyKg: 100.0,
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Balance Due formula: grandTotal + debitNotes - creditNotes - payments', () async {
      // 1. Create original invoice for ₹10,000
      final origDate = DateTime(2026, 5, 10);
      final origInvoiceId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-1001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: origDate,
          subtotal: 10000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 10000.0,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Check balance initially
      var balanceDetails = await repo.getInvoiceBalanceDetails(origInvoiceId);
      expect(balanceDetails.invoice.grandTotal, 10000.0);
      expect(balanceDetails.balanceDue, 10000.0);

      // 2. Add Debit Note for ₹2,000 (additional charges)
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DN-1001',
          invoiceType: InvoiceType.debit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvoiceId),
          noteReason: const drift.Value(NoteReason.additional_charges),
          invoiceDate: DateTime(2026, 5, 15),
          subtotal: 2000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 2000.0,
          amountInWords: 'Two Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      balanceDetails = await repo.getInvoiceBalanceDetails(origInvoiceId);
      expect(balanceDetails.totalDebitNotes, 2000.0);
      expect(balanceDetails.balanceDue, 12000.0); // 10000 + 2000

      // 3. Add Credit Note for ₹3,000 (discount/price correction)
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-1001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvoiceId),
          noteReason: const drift.Value(NoteReason.price_correction),
          invoiceDate: DateTime(2026, 5, 20),
          subtotal: 3000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 3000.0,
          amountInWords: 'Three Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      balanceDetails = await repo.getInvoiceBalanceDetails(origInvoiceId);
      expect(balanceDetails.totalCreditNotes, 3000.0);
      expect(balanceDetails.balanceDue, 9000.0); // 10000 + 2000 - 3000

      // 4. Record partial payment of ₹4,000
      await repo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: origInvoiceId,
          paymentDate: DateTime(2026, 5, 25),
          amount: 4000.0,
          paymentMode: PaymentMode.bankTransfer,
          referenceNo: const drift.Value('NEFT12345'),
        ),
      );

      balanceDetails = await repo.getInvoiceBalanceDetails(origInvoiceId);
      expect(balanceDetails.totalPaid, 4000.0);
      // Balance due = 10000 + 2000 - 3000 - 4000 = 5000
      expect(balanceDetails.balanceDue, 5000.0);

      // Check status: partiallyPaid
      final updatedOrig = await repo.getInvoiceById(origInvoiceId);
      expect(updatedOrig.status, InvoiceStatus.partiallyPaid);
    });

    test('Remaining creditable amount validation cap', () async {
      final origInvoiceId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-2001',
          invoiceType: InvoiceType.salesTaxInvoice,
          customerId: customerId,
          invoiceDate: DateTime(2026, 6, 1),
          subtotal: 10000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 10000.0,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // First credit note: 4,000
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-2001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvoiceId),
          noteReason: const drift.Value(NoteReason.sales_return),
          invoiceDate: DateTime(2026, 6, 5),
          subtotal: 4000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 4000.0,
          amountInWords: 'Four Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Add a debit note: 1,500
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DN-2001',
          invoiceType: InvoiceType.debit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origInvoiceId),
          noteReason: const drift.Value(NoteReason.additional_charges),
          invoiceDate: DateTime(2026, 6, 10),
          subtotal: 1500.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 1500.0,
          amountInWords: 'One Thousand Five Hundred Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Remaining creditable = 10,000 - 4,000 + 1,500 = 7,500
      final remaining = await repo.getRemainingCreditableAmount(origInvoiceId);
      expect(remaining, 7500.0);
    });

    test('Customer Ledger & Single Ledger Export matches Outstanding', () async {
      // Create Invoice: ₹10,000
      final invDate = DateTime(2026, 4, 10);
      final origId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-3001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: invDate,
          subtotal: 10000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 10000.0,
          amountInWords: 'Ten Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Debit note: ₹2,000
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DN-3001',
          invoiceType: InvoiceType.debit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origId),
          invoiceDate: DateTime(2026, 4, 15),
          subtotal: 2000.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 2000.0,
          amountInWords: 'Two Thousand Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Credit note: ₹1,500
      await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-3001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origId),
          invoiceDate: DateTime(2026, 4, 20),
          subtotal: 1500.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 1500.0,
          amountInWords: 'One Thousand Five Hundred Only',
          status: InvoiceStatus.sent,
        ),
        [],
      );

      // Partial payment: ₹3,000
      await repo.addPayment(
        PaymentsCompanion.insert(
          invoiceId: origId,
          paymentDate: DateTime(2026, 4, 25),
          amount: 3000.0,
          paymentMode: PaymentMode.cash,
        ),
      );

      // Net Outstanding = 10,000 (INV) + 2,000 (DN) - 1,500 (CN) - 3,000 (PAY) = 7,500
      final ledgerResult = await repo.getCustomerLedger(customerId);
      expect(ledgerResult.totalOutstanding, 7500.0);

      // Check Full Ledger Statement
      final statement = await repo.getCustomerLedgerStatement(
        customerId: customerId,
        fromDate: DateTime(2026, 4, 1),
        toDate: DateTime(2026, 4, 30),
      );

      expect(statement.closingBalance, 7500.0);
      expect(statement.closingBalance, equals(ledgerResult.totalOutstanding));

      // Verify that debit note is in Debit column and credit note is in Credit column
      final dnLine = statement.entries.firstWhere((e) => e.document.startsWith('Debit Note'));
      expect(dnLine.debit, 2000.0);
      expect(dnLine.credit ?? 0.0, 0.0);

      final cnLine = statement.entries.firstWhere((e) => e.document.startsWith('Credit Note'));
      expect(cnLine.debit ?? 0.0, 0.0);
      expect(cnLine.credit, 1500.0);

      // Check Outstanding Bills Statement
      final outstandingStatement = await repo.getCustomerOutstandingStatement(customerId: customerId);
      expect(outstandingStatement.totalOutstanding, 7500.0);
      expect(outstandingStatement.totalOutstanding, equals(ledgerResult.totalOutstanding));
      expect(outstandingStatement.bills.length, 1);
      expect(outstandingStatement.bills.first.balanceDue, 7500.0);
    });

    test('Stock movement on sales_return credit note: increments stock and reverts on draft delete', () async {
      // Initial stock: 100 kg
      var stock = await (db.select(db.copperStock)..where((t) => t.id.equals(copperStockId))).getSingle();
      expect(stock.stockQtyKg, 100.0);

      // Create draft credit note with returnStockToInventory: true
      final draftCnId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-DRAFT-01',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          noteReason: const drift.Value(NoteReason.sales_return),
          invoiceDate: DateTime(2026, 6, 1),
          subtotal: 8500.0,
          discountAmount: 0.0,
          cgstAmount: 0.0,
          sgstAmount: 0.0,
          grandTotal: 8500.0,
          amountInWords: 'Eight Thousand Five Hundred Only',
          status: InvoiceStatus.draft,
        ),
        [
          InvoiceItemsCompanion.insert(
            invoiceId: 0,
            itemSourceType: ItemSourceType.copperStock,
            copperStockId: drift.Value(copperStockId),
            description: 'Enamelled Copper Wire 22 SWG',
            qty: const drift.Value(10.0), // 10 kg returned
            unitPrice: 850.0,
            lineTotal: 8500.0,
          ),
        ],
        returnStockToInventory: true,
      );

      // Stock should now be 110 kg
      stock = await (db.select(db.copperStock)..where((t) => t.id.equals(copperStockId))).getSingle();
      expect(stock.stockQtyKg, 110.0);

      // Verify stock movement record
      final movements = await (db.select(db.stockMovements)..where((t) => t.referenceInvoiceId.equals(draftCnId))).get();
      expect(movements.length, 1);
      expect(movements.first.movementType, MovementType.sales_return_in);
      expect(movements.first.weightKg, 10.0);

      // Delete draft note: should reverse stock back to 100 kg
      await repo.deleteInvoice(draftCnId);
      stock = await (db.select(db.copperStock)..where((t) => t.id.equals(copperStockId))).getSingle();
      expect(stock.stockQtyKg, 100.0);
    });

    test('Generates Credit Note and Debit Note sample PDFs correctly', () async {
      final company = CompanySetting(
        id: 1,
        companyName: 'Star Electric Works',
        address: 'GIDC Industrial Area, Makarpura, Vadodara - 390010',
        phone: '0265-2641234',
        email: 'info@starelectric.com',
        gstin: '24AAAAA0000A1Z5',
        bankName: 'State Bank of India',
        bankAccountNo: '12345678901',
        bankIfsc: 'SBIN0001234',
        upiId: 'starelectric@sbi',
        eInvoiceApplicable: false,
        isRegistered: true,
      );

      final customer = await custRepo.getCustomerById(customerId);

      final origId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'INV-26270001',
          invoiceType: InvoiceType.serviceTaxInvoice,
          customerId: customerId,
          invoiceDate: DateTime(2026, 5, 1),
          subtotal: 10000.0,
          discountAmount: 0.0,
          cgstAmount: 900.0,
          sgstAmount: 900.0,
          grandTotal: 11800.0,
          amountInWords: 'Eleven Thousand Eight Hundred Only',
          status: InvoiceStatus.paid,
        ),
        [],
      );
      final origInvoice = await repo.getInvoiceById(origId);

      // Credit Note PDF
      final cnId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'CN-26270001',
          invoiceType: InvoiceType.credit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origId),
          noteReason: const drift.Value(NoteReason.sales_return),
          noteReasonText: const drift.Value('Defective winding materials returned'),
          invoiceDate: DateTime(2026, 5, 15),
          subtotal: 2000.0,
          discountAmount: 0.0,
          cgstAmount: 180.0,
          sgstAmount: 180.0,
          grandTotal: 2360.0,
          amountInWords: 'Two Thousand Three Hundred Sixty Only',
          status: InvoiceStatus.sent,
        ),
        [
          InvoiceItemsCompanion.insert(
            invoiceId: 0,
            itemSourceType: ItemSourceType.custom,
            description: 'Returned 22 SWG Enamelled Wire',
            unitPrice: 2000.0,
            qty: const drift.Value(1.0),
            gstRate: const drift.Value(18.0),
            lineTotal: 2000.0,
          ),
        ],
      );
      final cnInvoice = await repo.getInvoiceById(cnId);
      final cnItems = await repo.getItemsForInvoice(cnId);

      final cnBytes = await InvoicePdfGenerator.generate(
        company: company,
        invoice: cnInvoice,
        items: cnItems,
        customer: customer,
        originalInvoice: origInvoice,
      );

      expect(cnBytes.isNotEmpty, isTrue);

      // Debit Note PDF
      final dnId = await repo.createInvoiceWithItems(
        InvoicesCompanion.insert(
          invoiceNo: 'DN-26270001',
          invoiceType: InvoiceType.debit_note,
          customerId: customerId,
          originalInvoiceId: drift.Value(origId),
          noteReason: const drift.Value(NoteReason.additional_charges),
          noteReasonText: const drift.Value('Additional testing and transport charges'),
          invoiceDate: DateTime(2026, 5, 16),
          subtotal: 1500.0,
          discountAmount: 0.0,
          cgstAmount: 135.0,
          sgstAmount: 135.0,
          grandTotal: 1770.0,
          amountInWords: 'One Thousand Seven Hundred Seventy Only',
          status: InvoiceStatus.sent,
        ),
        [
          InvoiceItemsCompanion.insert(
            invoiceId: 0,
            itemSourceType: ItemSourceType.custom,
            description: 'Special surge withstand testing fee',
            unitPrice: 1500.0,
            qty: const drift.Value(1.0),
            gstRate: const drift.Value(18.0),
            lineTotal: 1500.0,
          ),
        ],
      );
      final dnInvoice = await repo.getInvoiceById(dnId);
      final dnItems = await repo.getItemsForInvoice(dnId);

      final dnBytes = await InvoicePdfGenerator.generate(
        company: company,
        invoice: dnInvoice,
        items: dnItems,
        customer: customer,
        originalInvoice: origInvoice,
      );

      expect(dnBytes.isNotEmpty, isTrue);

      // Save sample PDFs to artifacts directory
      final artifactDir = '/Users/nodetolearn/.gemini/antigravity/brain/73056598-9f94-4e14-9a2c-092d709cd64c';
      if (Directory(artifactDir).existsSync()) {
        await File('$artifactDir/sample_credit_note.pdf').writeAsBytes(cnBytes);
        await File('$artifactDir/sample_debit_note.pdf').writeAsBytes(dnBytes);
      }
    });
  });
}
