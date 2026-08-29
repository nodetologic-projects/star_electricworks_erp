import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/invoices.dart';
import 'package:starelectricerp/data/tables/invoice_items.dart';
import 'package:starelectricerp/data/tables/enums.dart';

void main() {
  testWidgets('Generate PDF', (WidgetTester tester) async {
    print("Generating PDF...");
    
    final company = CompanySetting(
      id: 1,
      companyName: 'Star Electric Works',
      address: '123 Fake St',
      phone: '1234567890',
      email: 'test@example.com',
      gstin: '22AAAAA0000A1Z5',
      bankName: 'HDFC',
      bankAccountNo: '123456',
      bankIfsc: 'HDFC0001',
      upiId: 'test@upi',
      eInvoiceApplicable: false,
    );
    
    final invoice = Invoice(
      id: 1,
      invoiceNo: 'INV-001',
      invoiceType: InvoiceType.salesTaxInvoice,
      customerId: 1,
      invoiceDate: DateTime.now(),
      subtotal: 100.0,
      discountAmount: 0.0,
      cgstAmount: 9.0,
      sgstAmount: 9.0,
      igstAmount: 0.0,
      grandTotal: 118.0,
      amountInWords: 'One Hundred Eighteen',
      status: InvoiceStatus.draft,
      requiresEWayBill: false,
      requiresEInvoice: false,
      createdAt: DateTime.now(),
    );
    
    final customer = Customer(
      id: 1,
      name: 'Test Customer',
      address: '456 Client Rd',
      state: 'Maharashtra',
      phone: '123',
      email: 'test2@example.com',
      isActive: true,
      createdAt: DateTime.now(),
    );
    
    final items = [
      InvoiceItem(
        id: 1,
        invoiceId: 1,
        itemSourceType: ItemSourceType.custom,
        description: 'Test Item',
        unitPrice: 100.0,
        lineTotal: 100.0,
      )
    ];
    
    try {
      final pdfBytes = await InvoicePdfGenerator.generate(
        copyLabels: ['ORIGINAL'],
        company: company,
        invoice: invoice,
        customer: customer,
        items: items,
        totalPaid: 0.0,
      );
      
      File('test_invoice.pdf').writeAsBytesSync(pdfBytes);
      print("Saved test_invoice.pdf");
    } catch (e) {
      print("Error: $e");
    }
  });
}
