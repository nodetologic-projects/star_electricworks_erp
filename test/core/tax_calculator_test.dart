import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/tax_calculator.dart';
import 'package:starelectricerp/data/tables/enums.dart';

void main() {
  group('TaxCalculator', () {
    test('Calculates correctly for Service Tax Invoice (Standard)', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.serviceTaxInvoice,
        items: [
          InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0),
        ],
      );

      expect(result.subtotal, 1000.0);
      expect(result.cgstAmount, 90.0);
      expect(result.sgstAmount, 90.0);
      expect(result.grandTotal, 1180.0);
    });

    test('Skips tax for Bill of Supply', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.billOfSupply,
        items: [
          InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0), // Even if rate is present, should ignore
        ],
      );

      expect(result.subtotal, 1000.0);
      expect(result.cgstAmount, 0.0);
      expect(result.sgstAmount, 0.0);
      expect(result.grandTotal, 1000.0);
    });

    test('Skips tax for Delivery Challan', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.deliveryChallan,
        items: [
          InvoiceLineItemInput(lineTotal: 500.0, gstRate: 5.0),
        ],
        deliveryCharge: 50.0,
      );

      expect(result.subtotal, 500.0);
      expect(result.cgstAmount, 0.0);
      expect(result.sgstAmount, 0.0);
      expect(result.grandTotal, 550.0);
    });

    test('Handles flat discount proportionally on taxes', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: [
          InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0), // 180 total tax originally
        ],
        bundleDiscountValue: 100.0, // taxable becomes 900
      );

      expect(result.subtotal, 1000.0);
      expect(result.discountAmount, 100.0);
      expect(result.taxableAmount, 900.0);
      expect(result.cgstAmount, 81.0); // 9% of 900
      expect(result.sgstAmount, 81.0);
      expect(result.grandTotal, 1062.0); // 900 + 162
    });

    test('Handles percentage discount proportionally on taxes', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: [
          InvoiceLineItemInput(lineTotal: 2000.0, gstRate: 12.0),
        ],
        bundleDiscountValue: 10.0,
        isBundleDiscountPercentage: true,
      );

      expect(result.subtotal, 2000.0);
      expect(result.discountAmount, 200.0);
      expect(result.taxableAmount, 1800.0);
      expect(result.cgstAmount, 108.0); // 6% of 1800
      expect(result.sgstAmount, 108.0);
      expect(result.grandTotal, 2016.0); // 1800 + 216
    });

    test('Rounds grand total to nearest rupee', () {
      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: [
          InvoiceLineItemInput(lineTotal: 99.50, gstRate: 18.0), // Tax: 17.91
        ],
      );

      // Raw = 99.50 + 17.91 = 117.41 -> 117
      expect(result.subtotal, 99.50);
      expect(result.cgstAmount, closeTo(8.955, 0.01));
      expect(result.sgstAmount, closeTo(8.955, 0.01));
      expect(result.grandTotal, 117.0);
      
      final result2 = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: [
          InvoiceLineItemInput(lineTotal: 100.49, gstRate: 18.0), // Tax: 18.0882
        ],
      );

      // Raw = 100.49 + 18.0882 = 118.5782 -> 119
      expect(result2.grandTotal, 119.0);
    });
  });
}
