import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/tax_calculator.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';
import 'package:starelectricerp/features/quotations/pdf/quotation_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate Sample PDFs for all 5 invoice types and quotation', () async {
    final company = CompanySetting.fromJson({
      'id': 1,
      'companyName': 'Star Electric Works',
      'address': 'Plot No. 42, GIDC Industrial Estate, Makarpura, Vadodara, Gujarat - 390010',
      'phone': '+91 98765 43210',
      'email': 'accounts@starelectric.com',
      'gstin': '24AAACS1234A1Z5',
      'bankName': 'State Bank of India',
      'bankAccountNo': '123456789012',
      'bankIfsc': 'SBIN0001234',
      'upiId': 'starelectric@upi',
      'eInvoiceApplicable': false,
      'isRegistered': true,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    // 1. Service Tax Invoice (Gujarati text + ₹ in QR)
    final gujaratiCustomer = Customer(
      id: 1,
      name: 'પટેલ એન્જિનિયરિંગ એન્ડ મોટર સર્વિસ',
      address: 'દુકાન નં. ૪૨, જીઆઈડીસી, મકરપુરા, વડોદરા',
      state: 'Gujarat',
      phone: '9898012345',
      email: 'patel@example.com',
      gstin: '24BBBCD5678B1Z2',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final serviceItemsInput = [
      InvoiceLineItemInput(lineTotal: 45000.0, discountPercent: 10.0, gstRate: 18.0),
    ];
    final serviceTotals = TaxCalculator.calculate(
      invoiceType: InvoiceType.serviceTaxInvoice,
      items: serviceItemsInput,
      useIgst: false,
    );

    final serviceInvoice = Invoice(
      id: 101,
      invoiceNo: 'SRV/2026-27/001',
      invoiceType: InvoiceType.serviceTaxInvoice,
      customerId: gujaratiCustomer.id,
      invoiceDate: DateTime(2026, 10, 27),
      dueDate: DateTime(2026, 11, 26),
      subtotal: serviceTotals.subtotal,
      discountAmount: serviceTotals.discountAmount,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: true,
      cgstAmount: serviceTotals.cgstAmount,
      sgstAmount: serviceTotals.sgstAmount,
      igstAmount: serviceTotals.igstAmount,
      useIgst: false,
      grandTotal: serviceTotals.grandTotal,
      amountInWords: 'Forty-Seven Thousand Seven Hundred Ninety',
      status: InvoiceStatus.draft,
      requiresEWayBill: false,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final serviceItems = [
      InvoiceItem(
        id: 1,
        invoiceId: 101,
        itemSourceType: ItemSourceType.custom,
        description: 'ઇન્ડસ્ટ્રીયલ મોટર રિવાઇન્ડિંગ 50HP\n**સંપૂર્ણ રોટર અને સ્ટેટર વાઇન્ડિંગ સર્વિસ**',
        hsnCode: '998719',
        qty: 1,
        unitPrice: 45000.0,
        discountPercent: 10.0,
        gstRate: 18.0,
        lineTotal: 45000.0,
      ),
    ];

    final servicePdf = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: serviceInvoice,
      customer: gujaratiCustomer,
      items: serviceItems,
      totalPaid: 10000.0, // Partial paid to test Amount Due & UPI QR label
    );
    await File('sample_service_tax_invoice.pdf').writeAsBytes(servicePdf);

    // 2. Sales Tax Invoice (Devanagari text + IGST mode)
    final hindiCustomer = Customer(
      id: 2,
      name: 'शर्मा इलेक्ट्रिकल्स एंड ट्रांसफार्मर वर्क्स',
      address: 'प्लॉट १०, एमआईडीसी, अंधेरी पूर्व, मुंबई',
      state: 'Maharashtra',
      phone: '9876543210',
      email: 'sharma@example.com',
      gstin: '27CCCCE9012C1Z8',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final salesItemsInput = [
      InvoiceLineItemInput(lineTotal: 47500.0, discountPercent: 5.0, gstRate: 18.0),
      InvoiceLineItemInput(lineTotal: 12000.0, discountPercent: 0.0, gstRate: 18.0),
    ];
    final salesTotals = TaxCalculator.calculate(
      invoiceType: InvoiceType.salesTaxInvoice,
      items: salesItemsInput,
      useIgst: true,
    );

    final salesInvoice = Invoice(
      id: 102,
      invoiceNo: 'SAL/2026-27/002',
      invoiceType: InvoiceType.salesTaxInvoice,
      customerId: hindiCustomer.id,
      invoiceDate: DateTime(2026, 10, 27),
      dueDate: DateTime(2026, 11, 26),
      subtotal: salesTotals.subtotal,
      discountAmount: salesTotals.discountAmount,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: true,
      cgstAmount: salesTotals.cgstAmount,
      sgstAmount: salesTotals.sgstAmount,
      igstAmount: salesTotals.igstAmount,
      useIgst: true,
      grandTotal: salesTotals.grandTotal,
      amountInWords: 'Sixty-Seven Thousand Three Hundred Ninety-Nine',
      status: InvoiceStatus.draft,
      requiresEWayBill: true,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final salesItems = [
      InvoiceItem(
        id: 2,
        invoiceId: 102,
        itemSourceType: ItemSourceType.copperStock,
        description: 'सुपर एनामल्ड कॉपर वाइंडिंग वायर 21 SWG\n**प्रीमियम कॉपर ग्रेड 99.9% शुद्धता**',
        hsnCode: '85441110',
        qty: 50,
        unitPrice: 950.0,
        discountPercent: 5.0,
        gstRate: 18.0,
        lineTotal: 47500.0,
      ),
      InvoiceItem(
        id: 3,
        invoiceId: 102,
        itemSourceType: ItemSourceType.custom,
        description: 'इंसुलेशन पेपर और वार्निश सेट',
        hsnCode: '85469000',
        qty: 10,
        unitPrice: 1200.0,
        discountPercent: 0.0,
        gstRate: 18.0,
        lineTotal: 12000.0,
      ),
    ];

    final salesPdf = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: salesInvoice,
      customer: hindiCustomer,
      items: salesItems,
      totalPaid: 0.0,
    );
    await File('sample_sales_tax_invoice.pdf').writeAsBytes(salesPdf);

    // 3. Bill of Supply (Large numbers e.g. 182675.80)
    final englishCustomer = Customer(
      id: 3,
      name: 'Reliable Heavy Engineering Industries Ltd',
      address: 'Plot 77, GIDC Industrial Estate, Waghodia, Vadodara',
      state: 'Gujarat',
      phone: '9825098250',
      email: 'accounts@reliableheavy.com',
      gstin: '24DDDD1111D1Z9',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final bosItemsInput = [
      InvoiceLineItemInput(lineTotal: 182675.80, discountPercent: 0.0, gstRate: 0.0),
    ];
    final bosTotals = TaxCalculator.calculate(
      invoiceType: InvoiceType.billOfSupply,
      items: bosItemsInput,
      useIgst: false,
    );

    final bosInvoice = Invoice(
      id: 103,
      invoiceNo: 'BOS/2026-27/003',
      invoiceType: InvoiceType.billOfSupply,
      customerId: englishCustomer.id,
      invoiceDate: DateTime(2026, 10, 27),
      dueDate: DateTime(2026, 11, 26),
      subtotal: bosTotals.subtotal,
      discountAmount: 0.0,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: false,
      cgstAmount: 0.0,
      sgstAmount: 0.0,
      igstAmount: 0.0,
      useIgst: false,
      grandTotal: bosTotals.grandTotal,
      amountInWords: 'One Lakh Eighty-Two Thousand Six Hundred Seventy-Six',
      status: InvoiceStatus.draft,
      requiresEWayBill: true,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final bosItems = [
      InvoiceItem(
        id: 4,
        invoiceId: 103,
        itemSourceType: ItemSourceType.custom,
        description: 'Exempt Electrical Machinery Overhaul & Assembly\n**Includes testing and calibration certification**',
        hsnCode: '8501',
        qty: 1,
        unitPrice: 182675.80,
        discountPercent: 0.0,
        gstRate: 0.0,
        lineTotal: 182675.80,
      ),
    ];

    final bosPdf = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: bosInvoice,
      customer: englishCustomer,
      items: bosItems,
      totalPaid: 0.0,
    );
    await File('sample_bill_of_supply.pdf').writeAsBytes(bosPdf);

    // 4. Purchase Voucher
    final pvItemsInput = [
      InvoiceLineItemInput(lineTotal: 15000.0, discountPercent: 0.0, gstRate: 18.0),
    ];
    final pvTotals = TaxCalculator.calculate(
      invoiceType: InvoiceType.purchaseVoucher,
      items: pvItemsInput,
      useIgst: false,
    );

    final pvInvoice = Invoice(
      id: 104,
      invoiceNo: 'PUR/2026-27/004',
      invoiceType: InvoiceType.purchaseVoucher,
      customerId: localCustomer(englishCustomer),
      invoiceDate: DateTime(2026, 10, 27),
      subtotal: pvTotals.subtotal,
      discountAmount: 0.0,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: false,
      cgstAmount: pvTotals.cgstAmount,
      sgstAmount: pvTotals.sgstAmount,
      igstAmount: 0.0,
      useIgst: false,
      grandTotal: pvTotals.grandTotal,
      amountInWords: 'Seventeen Thousand Seven Hundred',
      status: InvoiceStatus.draft,
      requiresEWayBill: false,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final pvItems = [
      InvoiceItem(
        id: 5,
        invoiceId: 104,
        itemSourceType: ItemSourceType.custom,
        description: 'Raw Scrap Copper Material Purchase (RCM)',
        hsnCode: '74040012',
        qty: 25,
        unitPrice: 600.0,
        discountPercent: 0.0,
        gstRate: 18.0,
        lineTotal: 15000.0,
      ),
    ];

    final pvPdf = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: pvInvoice,
      customer: englishCustomer,
      items: pvItems,
      totalPaid: 17700.0,
    );
    await File('sample_purchase_voucher.pdf').writeAsBytes(pvPdf);

    // 5. Delivery Challan
    final dcInvoice = Invoice(
      id: 105,
      invoiceNo: 'DC/2026-27/005',
      invoiceType: InvoiceType.deliveryChallan,
      customerId: gujaratiCustomer.id,
      invoiceDate: DateTime(2026, 10, 27),
      subtotal: 50000.0,
      discountAmount: 0.0,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: false,
      cgstAmount: 0.0,
      sgstAmount: 0.0,
      igstAmount: 0.0,
      useIgst: false,
      grandTotal: 50000.0,
      amountInWords: 'Fifty Thousand',
      status: InvoiceStatus.draft,
      requiresEWayBill: true,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
      gpNumber: 'GJ-06-AX-1234',
      gpDate: DateTime(2026, 10, 27),
      placeOfSupply: 'Vadodara, Gujarat',
    );

    final dcItems = [
      InvoiceItem(
        id: 6,
        invoiceId: 105,
        itemSourceType: ItemSourceType.custom,
        description: 'Siemens 3-Phase Induction Motor 50HP\n**For Job Work / Rewinding Return**',
        hsnCode: '85015210',
        qty: 1,
        unitPrice: 50000.0,
        discountPercent: 0.0,
        gstRate: 0.0,
        lineTotal: 50000.0,
      ),
    ];

    final dcPdf = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: dcInvoice,
      customer: gujaratiCustomer,
      items: dcItems,
      totalPaid: 0.0,
    );
    await File('sample_delivery_challan.pdf').writeAsBytes(dcPdf);

    // 6. Quotation (with Gujarati & ₹)
    final quote = Quotation(
      id: 106,
      quoteNo: 'QUO/2026-27/006',
      prospectiveCustomerName: 'શ્રી રામ એન્ટરપ્રાઇઝ (Shree Ram Enterprise)',
      prospectiveCustomerPhone: '+91 99099 12345',
      description: '50 HP હાઇ-સ્પીડ મોટર રીપેરીંગ અને કોપર વાઇન્ડિંગ સર્વિસ\nEstimated cost includes bearing change and testing.',
      estimatedAmount: 38500.0,
      validUntil: DateTime.now().add(const Duration(days: 15)),
      createdAt: DateTime.now(),
      status: QuotationStatus.draft,
    );

    final quotePdf = await QuotationPdfGenerator.generate(
      company: company,
      data: QuotationWithCustomer(quotation: quote),
    );
    await File('sample_quotation.pdf').writeAsBytes(quotePdf);
  });
}

int localCustomer(Customer c) => c.id;
