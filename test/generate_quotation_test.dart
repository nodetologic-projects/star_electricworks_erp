import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/quotations/pdf/quotation_pdf.dart';

void main() {
  test('Generate Quotation PDF', () async {
    final quote = Quotation(
      id: 1,
      quoteNo: 'QUO-0001',
      prospectiveCustomerName: 'John Doe',
      description: 'Test Quotation',
      estimatedAmount: 1000.0,
      validUntil: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now(),
      status: QuotationStatus.draft,
    );

    final data = QuotationWithCustomer(
      quotation: quote,
    );

    // Mocking CompanySetting directly with json
    final company = CompanySetting.fromJson({
      'id': 1,
      'companyName': 'Test Company',
      'address': '123 Test St',
      'phone': '1234567890',
      'email': 'test@example.com',
      'gstin': '123',
      'bankName': 'Test Bank',
      'bankAccountNo': '123456789',
      'bankIfsc': 'TEST0001234',
      'eInvoiceApplicable': false,
      'isRegistered': true,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    final pdfBytes = await QuotationPdfGenerator.generate(company: company, data: data);
    final file = File('sample_quotation.pdf');
    await file.writeAsBytes(pdfBytes);
    print('Generated sample_quotation.pdf');
  });
}
