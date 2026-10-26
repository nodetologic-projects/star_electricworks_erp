import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/tax_calculator.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate Sample Invoices for CGST+SGST and IGST modes', () async {
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

    final localCustomer = Customer(
      id: 1,
      name: 'Gujarat Engineering Corp',
      address: 'Shop 12, GIDC, Vadodara',
      state: 'Gujarat',
      phone: '9898989898',
      email: 'contact@gujeng.com',
      gstin: '24BBBCD5678B1Z2',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final outOfStateCustomer = Customer(
      id: 2,
      name: 'Maharashtra Heavy Electricals Ltd',
      address: 'Plot 88, MIDC, Andheri East, Mumbai',
      state: 'Maharashtra',
      phone: '9765432100',
      email: 'procurement@mhel.co.in',
      gstin: '27CCCCE9012C1Z8',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final lineInputs = [
      InvoiceLineItemInput(lineTotal: 50000.0, discountPercent: 10.0, gstRate: 18.0),
      InvoiceLineItemInput(lineTotal: 25000.0, discountPercent: 5.0, gstRate: 12.0),
    ];

    // 1. CGST + SGST Invoice
    final totalsCgstSgst = TaxCalculator.calculate(
      invoiceType: InvoiceType.salesTaxInvoice,
      items: lineInputs,
      useIgst: false,
    );

    final invoiceCgstSgst = Invoice(
      id: 101,
      invoiceNo: 'INV/2026-27/001',
      invoiceType: InvoiceType.salesTaxInvoice,
      customerId: localCustomer.id,
      invoiceDate: DateTime(2026, 10, 26),
      dueDate: DateTime(2026, 11, 25),
      subtotal: totalsCgstSgst.subtotal,
      discountAmount: totalsCgstSgst.discountAmount,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: true,
      cgstAmount: totalsCgstSgst.cgstAmount,
      sgstAmount: totalsCgstSgst.sgstAmount,
      igstAmount: totalsCgstSgst.igstAmount,
      useIgst: false,
      grandTotal: totalsCgstSgst.grandTotal,
      amountInWords: 'Seventy-Seven Thousand Eight Hundred Eighty',
      status: InvoiceStatus.draft,
      requiresEWayBill: totalsCgstSgst.grandTotal >= 50000,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final items = [
      InvoiceItem(
        id: 1,
        invoiceId: 101,
        itemSourceType: ItemSourceType.custom,
        description: 'Industrial Motor Rewinding & Servicing 50HP\n**Complete rotor inspection & copper rewinding**',
        hsnCode: '998719',
        qty: 1,
        unitPrice: 50000.0,
        discountPercent: 10.0,
        gstRate: 18.0,
        lineTotal: 50000.0,
      ),
      InvoiceItem(
        id: 2,
        invoiceId: 101,
        itemSourceType: ItemSourceType.copperStock,
        description: 'Super Enamelled Copper Winding Wire 21 SWG',
        hsnCode: '85441110',
        qty: 25,
        unitPrice: 1000.0,
        discountPercent: 5.0,
        gstRate: 12.0,
        lineTotal: 25000.0,
      ),
    ];

    final pdfBytesCgst = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: invoiceCgstSgst,
      customer: localCustomer,
      items: items,
      totalPaid: 0.0,
    );

    await File('sample_cgst_sgst.pdf').writeAsBytes(pdfBytesCgst);
    print('Generated sample_cgst_sgst.pdf');

    // 2. IGST Invoice
    final totalsIgst = TaxCalculator.calculate(
      invoiceType: InvoiceType.salesTaxInvoice,
      items: lineInputs,
      useIgst: true,
    );

    final invoiceIgst = Invoice(
      id: 102,
      invoiceNo: 'INV/2026-27/002',
      invoiceType: InvoiceType.salesTaxInvoice,
      customerId: outOfStateCustomer.id,
      invoiceDate: DateTime(2026, 10, 26),
      dueDate: DateTime(2026, 11, 25),
      subtotal: totalsIgst.subtotal,
      discountAmount: totalsIgst.discountAmount,
      isDiscountPercentage: false,
      distributeDiscountAcrossItems: true,
      cgstAmount: totalsIgst.cgstAmount,
      sgstAmount: totalsIgst.sgstAmount,
      igstAmount: totalsIgst.igstAmount,
      useIgst: true,
      grandTotal: totalsIgst.grandTotal,
      amountInWords: 'Seventy-Seven Thousand Eight Hundred Eighty',
      status: InvoiceStatus.draft,
      requiresEWayBill: totalsIgst.grandTotal >= 50000,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );

    final pdfBytesIgst = await InvoicePdfGenerator.generate(
      copyLabels: ['ORIGINAL FOR RECIPIENT'],
      company: company,
      invoice: invoiceIgst,
      customer: outOfStateCustomer,
      items: items,
      totalPaid: 0.0,
    );

    await File('sample_igst.pdf').writeAsBytes(pdfBytesIgst);
    print('Generated sample_igst.pdf');
  });
}
