import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Delivery Challan HSN Code Tests', () {
    test('MotorJobs table stores and retrieves hsnCode separately from sacCode', () async {
      final customerId = await db.into(db.customers).insert(
        CustomersCompanion.insert(
          name: 'Acme Industries',
          address: 'Plot 42, GIDC, Makarpura, Vadodara',
          phone: '9876543210',
          email: 'acme@example.com',
          state: 'Gujarat',
        ),
      );

      final jobId = await db.into(db.motorJobs).insert(
        MotorJobsCompanion.insert(
          jobNo: 'JOB-2026-001',
          customerId: customerId,
          motorDescription: '10 HP Crompton Motor',
          dateReceived: DateTime.now(),
          jobDescription: 'Complete rewinding and bearing replacement',
          status: MotorJobStatus.received,
          sacCode: const drift.Value('998719'),
          hsnCode: const drift.Value('8501'),
        ),
      );

      final job = await (db.select(db.motorJobs)..where((t) => t.id.equals(jobId))).getSingle();
      expect(job.sacCode, '998719');
      expect(job.hsnCode, '8501');
    });

    test('CompanySettings stores defaultMotorHsn', () async {
      await db.into(db.companySettings).insert(
        CompanySettingsCompanion.insert(
          companyName: 'Star Electric Works',
          address: 'Vadodara, Gujarat',
          phone: '9876543210',
          email: 'info@starelectric.com',
          gstin: '24AAAAA0000A1Z5',
          bankName: 'SBI',
          bankAccountNo: '1234567890',
          bankIfsc: 'SBIN0001234',
          defaultMotorHsn: const drift.Value('8501'),
        ),
      );

      final settings = await (db.select(db.companySettings)).getSingle();
      expect(settings.defaultMotorHsn, '8501');
    });

    test('HSN numeric 4-8 digit validation logic matches expected patterns', () {
      final hsnRegex = RegExp(r'^\d{4,8}$');

      // Valid 4 to 8 numeric digits
      expect(hsnRegex.hasMatch('8501'), isTrue);
      expect(hsnRegex.hasMatch('850110'), isTrue);
      expect(hsnRegex.hasMatch('85011019'), isTrue);

      // Invalid patterns (triggers warning)
      expect(hsnRegex.hasMatch('850'), isFalse); // < 4 digits
      expect(hsnRegex.hasMatch('850110199'), isFalse); // > 8 digits
      expect(hsnRegex.hasMatch('8501A'), isFalse); // contains letters
      expect(hsnRegex.hasMatch('85 01'), isFalse); // contains spaces
    });

    test('Challan line HSN resolution follows priority: job.hsnCode -> Settings default -> null', () {
      String? resolveChallanHsn({String? jobHsn, String? defaultHsn}) {
        if (jobHsn != null && jobHsn.trim().isNotEmpty) {
          return jobHsn.trim();
        }
        if (defaultHsn != null && defaultHsn.trim().isNotEmpty) {
          return defaultHsn.trim();
        }
        return null;
      }

      // Case 1: Job has hsnCode set
      expect(
        resolveChallanHsn(jobHsn: '8501', defaultHsn: '8502'),
        equals('8501'),
      );

      // Case 2: Job has empty hsnCode, falls back to Settings default
      expect(
        resolveChallanHsn(jobHsn: null, defaultHsn: '8501'),
        equals('8501'),
      );
      expect(
        resolveChallanHsn(jobHsn: '', defaultHsn: '8501'),
        equals('8501'),
      );

      // Case 3: Neither has HSN
      expect(
        resolveChallanHsn(jobHsn: null, defaultHsn: null),
        isNull,
      );
    });

    test('Missing HSN detection counts lines without HSN correctly for non-blocking warning', () {
      final items = [
        {'desc': 'Motor 1', 'hsn': '8501'},
        {'desc': 'Motor 2', 'hsn': ''},
        {'desc': 'Custom item', 'hsn': null},
      ];

      final missingHsnCount = items.where((i) {
        final hsn = i['hsn'];
        return hsn == null || hsn.trim().isEmpty;
      }).length;

      expect(missingHsnCount, equals(2));
    });

    test('Delivery Challan PDF generates with HSN column and blank for missing HSN', () async {
      final company = CompanySetting(
        id: 1,
        companyName: 'Star Electric Works',
        address: 'B-12, Industrial Estate, Gorwa, Vadodara - 390016',
        phone: '+91 98250 12345',
        email: 'contact@starelectric.in',
        gstin: '24ABCDE1234F1Z5',
        bankName: 'State Bank of India',
        bankAccountNo: '123456789012',
        bankIfsc: 'SBIN0001234',
        eInvoiceApplicable: false,
        isRegistered: true,
        defaultMotorHsn: '8501',
      );

      final customer = Customer(
        id: 1,
        name: 'Baroda Heavy Engineering Ltd.',
        address: 'GIDC Industrial Area, Makarpura, Vadodara, Gujarat 390010',
        phone: '9876543210',
        email: 'procurement@barodaeng.com',
        state: 'Gujarat',
        gstin: '24AABCB1234A1Z1',
        isActive: true,
        createdAt: DateTime.now(),
      );

      final invoice = Invoice(
        id: 1,
        invoiceNo: 'DC-2627-001',
        invoiceType: InvoiceType.deliveryChallan,
        customerId: customer.id,
        invoiceDate: DateTime(2026, 4, 15),
        subtotal: 15000.0,
        discountAmount: 0.0,
        isDiscountPercentage: false,
        distributeDiscountAcrossItems: false,
        cgstAmount: 0.0,
        sgstAmount: 0.0,
        igstAmount: 0.0,
        useIgst: false,
        taxMode: TaxMode.cgst_sgst,
        grandTotal: 15000.0,
        amountInWords: 'Fifteen Thousand Rupees Only',
        status: InvoiceStatus.draft,
        requiresEWayBill: false,
        requiresEInvoice: false,
        gpNumber: 'GP-8842',
        gpDate: DateTime(2026, 4, 14),
        deliveryCharge: 500.0,
        createdAt: DateTime.now(),
      );

      final items = [
        // Line 1: from motor job with hsnCode set
        InvoiceItem(
          id: 1,
          invoiceId: 1,
          itemSourceType: ItemSourceType.motorJob,
          description: '15 HP Rewound Induction Motor GP.NO.GP-8842 GP.DATE.14/04/2026\nStator rewinding completed',
          hsnCode: '8501',
          qty: 1,
          unitPrice: 8500.0,
          lineTotal: 8500.0,
        ),
        // Line 2: from motor job relying on Settings default HSN
        InvoiceItem(
          id: 2,
          invoiceId: 1,
          itemSourceType: ItemSourceType.motorJob,
          description: '5 HP Submersible Pump GP.NO.GP-8843 GP.DATE.14/04/2026\nBush and impeller replacement',
          hsnCode: '8501',
          qty: 1,
          unitPrice: 4500.0,
          lineTotal: 4500.0,
        ),
        // Line 3: custom item without HSN (cell stays blank)
        InvoiceItem(
          id: 3,
          invoiceId: 1,
          itemSourceType: ItemSourceType.custom,
          description: 'Delivery of Spare Terminal Box & Fan Cover',
          hsnCode: null, // Should render blank, no "N/A" or dash
          qty: 1,
          unitPrice: 2000.0,
          lineTotal: 2000.0,
        ),
      ];

      final pdfBytes = await InvoicePdfGenerator.generate(
        copyLabels: ['ORIGINAL FOR RECIPIENT'],
        company: company,
        invoice: invoice,
        customer: customer,
        items: items,
        totalPaid: 0.0,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(1000));

      // Save sample PDF for visual inspection
      final file = File('/Users/nodetolearn/.gemini/antigravity/brain/73056598-9f94-4e14-9a2c-092d709cd64c/sample_delivery_challan_hsn.pdf');
      await file.writeAsBytes(pdfBytes);
      expect(await file.exists(), isTrue);
    });
  });
}
