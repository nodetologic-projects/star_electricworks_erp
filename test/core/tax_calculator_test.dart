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

    test('No discount: line sums == totals', () {
      final items = [
        InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0),
        InvoiceLineItemInput(lineTotal: 2500.0, gstRate: 12.0),
        InvoiceLineItemInput(lineTotal: 500.0, gstRate: 0.0),
      ];

      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: items,
      );

      final sumLineDiscount =
          items.fold(0.0, (acc, i) => acc + i.discountAmount);
      final sumLineTaxable = items.fold(0.0, (acc, i) => acc + i.taxableAmount);
      final sumLineCgst = items.fold(0.0, (acc, i) => acc + i.cgstAmount);
      final sumLineSgst = items.fold(0.0, (acc, i) => acc + i.sgstAmount);
      final sumLineTotals = items.fold(0.0, (acc, i) => acc + i.totalWithTax);

      expect(sumLineDiscount, 0.0);
      expect(result.discountAmount, 0.0);
      expect(sumLineTaxable, result.taxableAmount);
      expect(sumLineCgst, result.cgstAmount);
      expect(sumLineSgst, result.sgstAmount);
      expect(sumLineCgst + sumLineSgst, result.cgstAmount + result.sgstAmount);
      expect(
        sumLineTotals,
        result.taxableAmount + result.cgstAmount + result.sgstAmount,
      );
      expect(sumLineTotals, result.grandTotal);
    });

    test('Single line with discount: line sums == totals', () {
      final items = [
        InvoiceLineItemInput(
          lineTotal: 100000.0,
          discountPercent: 10.0,
          gstRate: 28.0,
        ),
      ];

      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: items,
      );

      final item = items.first;
      expect(item.discountAmount, 10000.0);
      expect(item.taxableAmount, 90000.0);
      expect(item.cgstAmount, closeTo(12600.0, 0.01));
      expect(item.sgstAmount, closeTo(12600.0, 0.01));
      expect(item.totalGst, closeTo(25200.0, 0.01));
      expect(item.totalWithTax, closeTo(115200.0, 0.01));

      final sumLineDiscount =
          items.fold(0.0, (acc, i) => acc + i.discountAmount);
      final sumLineTaxable = items.fold(0.0, (acc, i) => acc + i.taxableAmount);
      final sumLineCgst = items.fold(0.0, (acc, i) => acc + i.cgstAmount);
      final sumLineSgst = items.fold(0.0, (acc, i) => acc + i.sgstAmount);
      final sumLineTotals = items.fold(0.0, (acc, i) => acc + i.totalWithTax);

      expect(sumLineDiscount, result.discountAmount);
      expect(sumLineTaxable, result.taxableAmount);
      expect(sumLineCgst, result.cgstAmount);
      expect(sumLineSgst, result.sgstAmount);
      expect(sumLineCgst + sumLineSgst, result.cgstAmount + result.sgstAmount);
      expect(
        sumLineTotals,
        result.taxableAmount + result.cgstAmount + result.sgstAmount,
      );
      expect(sumLineTotals, result.grandTotal);
    });

    test(
      'Multiple lines with different GST rates and different discounts: line sums == totals',
      () {
        final items = [
          InvoiceLineItemInput(
            lineTotal: 5000.0,
            discountPercent: 5.0,
            gstRate: 18.0,
          ),
          InvoiceLineItemInput(
            lineTotal: 12000.0,
            discountPercent: 10.0,
            gstRate: 28.0,
          ),
          InvoiceLineItemInput(
            lineTotal: 3000.0,
            discountPercent: 0.0,
            gstRate: 5.0,
          ),
          InvoiceLineItemInput(
            lineTotal: 1500.0,
            discountPercent: 15.0,
            gstRate: 0.0,
          ),
        ];

        final result = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
        );

        final sumLineDiscount =
            items.fold(0.0, (acc, i) => acc + i.discountAmount);
        final sumLineTaxable =
            items.fold(0.0, (acc, i) => acc + i.taxableAmount);
        final sumLineCgst = items.fold(0.0, (acc, i) => acc + i.cgstAmount);
        final sumLineSgst = items.fold(0.0, (acc, i) => acc + i.sgstAmount);
        final sumLineTotals = items.fold(0.0, (acc, i) => acc + i.totalWithTax);

        expect(sumLineDiscount, result.discountAmount);
        expect(sumLineTaxable, result.taxableAmount);
        expect(sumLineCgst, result.cgstAmount);
        expect(sumLineSgst, result.sgstAmount);
        expect(sumLineCgst + sumLineSgst, result.cgstAmount + result.sgstAmount);
        expect(
          sumLineTotals,
          result.taxableAmount + result.cgstAmount + result.sgstAmount,
        );
        expect(sumLineTotals.roundToDouble(), result.grandTotal);
      },
    );

    test('Rounding case: line sums == totals (+- rounded off)', () {
      final items = [
        InvoiceLineItemInput(
          lineTotal: 99.50,
          discountPercent: 7.0,
          gstRate: 18.0,
        ),
        InvoiceLineItemInput(
          lineTotal: 149.25,
          discountPercent: 3.5,
          gstRate: 12.0,
        ),
      ];

      final result = TaxCalculator.calculate(
        invoiceType: InvoiceType.salesTaxInvoice,
        items: items,
      );

      final sumLineDiscount =
          items.fold(0.0, (acc, i) => acc + i.discountAmount);
      final sumLineTaxable = items.fold(0.0, (acc, i) => acc + i.taxableAmount);
      final sumLineCgst = items.fold(0.0, (acc, i) => acc + i.cgstAmount);
      final sumLineSgst = items.fold(0.0, (acc, i) => acc + i.sgstAmount);
      final sumLineTotals = items.fold(0.0, (acc, i) => acc + i.totalWithTax);

      expect(sumLineDiscount, result.discountAmount);
      expect(sumLineTaxable, result.taxableAmount);
      expect(sumLineCgst, result.cgstAmount);
      expect(sumLineSgst, result.sgstAmount);
      expect(sumLineCgst + sumLineSgst, result.cgstAmount + result.sgstAmount);

      final rawTotal =
          result.taxableAmount + result.cgstAmount + result.sgstAmount;
      final roundedOff = result.grandTotal - rawTotal;

      expect(sumLineTotals, closeTo(rawTotal, 0.0001));
      expect(sumLineTotals + roundedOff, result.grandTotal);
    });

    group('IGST Mode', () {
      test('Single rate with IGST: IGST total == CGST+SGST total, sum(line IGST) == totals-block tax', () {
        final items = [
          InvoiceLineItemInput(lineTotal: 10000.0, gstRate: 18.0),
        ];

        final resultCgstSgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: false,
        );

        final resultIgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: true,
        );

        expect(resultIgst.cgstAmount, 0.0);
        expect(resultIgst.sgstAmount, 0.0);
        expect(resultIgst.igstAmount, 1800.0);
        expect(resultIgst.igstAmount, resultCgstSgst.cgstAmount + resultCgstSgst.sgstAmount);
        expect(resultIgst.grandTotal, resultCgstSgst.grandTotal);

        final sumLineIgst = items.fold(0.0, (acc, i) => acc + i.igstAmount);
        expect(sumLineIgst, resultIgst.igstAmount);
      });

      test('Multiple rates with IGST: IGST total == CGST+SGST total, sum(line IGST) == totals-block tax', () {
        final items = [
          InvoiceLineItemInput(lineTotal: 5000.0, gstRate: 18.0),
          InvoiceLineItemInput(lineTotal: 12000.0, gstRate: 28.0),
          InvoiceLineItemInput(lineTotal: 3000.0, gstRate: 5.0),
          InvoiceLineItemInput(lineTotal: 1500.0, gstRate: 0.0),
        ];

        final resultCgstSgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.serviceTaxInvoice,
          items: items,
          useIgst: false,
        );

        final resultIgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.serviceTaxInvoice,
          items: items,
          useIgst: true,
        );

        expect(resultIgst.cgstAmount, 0.0);
        expect(resultIgst.sgstAmount, 0.0);
        expect(resultIgst.igstAmount, resultCgstSgst.cgstAmount + resultCgstSgst.sgstAmount);
        expect(resultIgst.grandTotal, resultCgstSgst.grandTotal);

        final sumLineIgst = items.fold(0.0, (acc, i) => acc + i.igstAmount);
        expect(sumLineIgst, resultIgst.igstAmount);
      });

      test('Per-line discount with IGST: IGST total == CGST+SGST total, sum(line IGST) == totals-block tax', () {
        final items = [
          InvoiceLineItemInput(
            lineTotal: 100000.0,
            discountPercent: 10.0,
            gstRate: 28.0,
          ),
          InvoiceLineItemInput(
            lineTotal: 25000.0,
            discountPercent: 5.0,
            gstRate: 18.0,
          ),
        ];

        final resultCgstSgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: false,
        );

        final resultIgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: true,
        );

        expect(resultIgst.cgstAmount, 0.0);
        expect(resultIgst.sgstAmount, 0.0);
        expect(resultIgst.igstAmount, resultCgstSgst.cgstAmount + resultCgstSgst.sgstAmount);
        expect(resultIgst.grandTotal, resultCgstSgst.grandTotal);

        final sumLineIgst = items.fold(0.0, (acc, i) => acc + i.igstAmount);
        expect(sumLineIgst, resultIgst.igstAmount);

        final sumLineTaxable = items.fold(0.0, (acc, i) => acc + i.taxableAmount);
        expect(sumLineTaxable, resultIgst.taxableAmount);
        expect(sumLineTaxable + resultIgst.igstAmount, resultIgst.grandTotal);
      });

      test('Rounding case with IGST: line sums == totals (+- rounded off)', () {
        final items = [
          InvoiceLineItemInput(
            lineTotal: 99.50,
            discountPercent: 7.0,
            gstRate: 18.0,
          ),
          InvoiceLineItemInput(
            lineTotal: 149.25,
            discountPercent: 3.5,
            gstRate: 12.0,
          ),
        ];

        final resultCgstSgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: false,
        );

        final resultIgst = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: items,
          useIgst: true,
        );

        expect(resultIgst.cgstAmount, 0.0);
        expect(resultIgst.sgstAmount, 0.0);
        expect(resultIgst.igstAmount, closeTo(resultCgstSgst.cgstAmount + resultCgstSgst.sgstAmount, 0.0001));
        expect(resultIgst.grandTotal, resultCgstSgst.grandTotal);

        final sumLineIgst = items.fold(0.0, (acc, i) => acc + i.igstAmount);
        expect(sumLineIgst, resultIgst.igstAmount);

        final sumLineTaxable = items.fold(0.0, (acc, i) => acc + i.taxableAmount);
        final rawTotal = sumLineTaxable + resultIgst.igstAmount;
        final roundedOff = resultIgst.grandTotal - rawTotal;
        expect(rawTotal + roundedOff, resultIgst.grandTotal);
      });

      test('Option 2 ("IGST + CGST + SGST"): single rate, mixed rates, per-line discount, rounding', () {
        // 1. Single rate
        final singleRateItems = [
          InvoiceLineItemInput(lineTotal: 50000.0, gstRate: 18.0),
        ];
        final opt1Single = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: singleRateItems,
          useIgst: false,
        );
        final opt2Single = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: singleRateItems,
          useIgst: true,
        );
        expect(opt2Single.cgstAmount, 0.0);
        expect(opt2Single.sgstAmount, 0.0);
        expect(opt2Single.igstAmount, opt1Single.cgstAmount + opt1Single.sgstAmount);
        expect(singleRateItems.fold(0.0, (acc, i) => acc + i.igstAmount), opt2Single.igstAmount);
        expect(opt2Single.grandTotal, opt1Single.grandTotal);

        // 2. Mixed rates
        final mixedRateItems = [
          InvoiceLineItemInput(lineTotal: 30000.0, gstRate: 18.0),
          InvoiceLineItemInput(lineTotal: 20000.0, gstRate: 12.0),
          InvoiceLineItemInput(lineTotal: 10000.0, gstRate: 5.0),
        ];
        final opt1Mixed = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: mixedRateItems,
          useIgst: false,
        );
        final opt2Mixed = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: mixedRateItems,
          useIgst: true,
        );
        expect(opt2Mixed.cgstAmount, 0.0);
        expect(opt2Mixed.sgstAmount, 0.0);
        expect(opt2Mixed.igstAmount, opt1Mixed.cgstAmount + opt1Mixed.sgstAmount);
        expect(mixedRateItems.fold(0.0, (acc, i) => acc + i.igstAmount), opt2Mixed.igstAmount);
        expect(opt2Mixed.grandTotal, opt1Mixed.grandTotal);

        // 3. With per-line discount
        final discountedItems = [
          InvoiceLineItemInput(lineTotal: 60000.0, discountPercent: 10.0, gstRate: 18.0),
          InvoiceLineItemInput(lineTotal: 40000.0, discountPercent: 5.0, gstRate: 12.0),
        ];
        final opt1Disc = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: discountedItems,
          useIgst: false,
        );
        final opt2Disc = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: discountedItems,
          useIgst: true,
        );
        expect(opt2Disc.cgstAmount, 0.0);
        expect(opt2Disc.sgstAmount, 0.0);
        expect(opt2Disc.igstAmount, opt1Disc.cgstAmount + opt1Disc.sgstAmount);
        expect(discountedItems.fold(0.0, (acc, i) => acc + i.igstAmount), opt2Disc.igstAmount);
        expect(opt2Disc.grandTotal, opt1Disc.grandTotal);

        // 4. Rounding
        final roundingItems = [
          InvoiceLineItemInput(lineTotal: 99.55, discountPercent: 3.3, gstRate: 18.0),
          InvoiceLineItemInput(lineTotal: 149.85, discountPercent: 7.1, gstRate: 12.0),
        ];
        final opt1Round = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: roundingItems,
          useIgst: false,
        );
        final opt2Round = TaxCalculator.calculate(
          invoiceType: InvoiceType.salesTaxInvoice,
          items: roundingItems,
          useIgst: true,
        );
        expect(opt2Round.cgstAmount, 0.0);
        expect(opt2Round.sgstAmount, 0.0);
        expect(opt2Round.igstAmount, closeTo(opt1Round.cgstAmount + opt1Round.sgstAmount, 0.0001));
        expect(roundingItems.fold(0.0, (acc, i) => acc + i.igstAmount), opt2Round.igstAmount);
        expect(opt2Round.grandTotal, opt1Round.grandTotal);
      });

      test('Bill of Supply and Delivery Challan ignore useIgst', () {
        final items = [
          InvoiceLineItemInput(lineTotal: 1000.0, gstRate: 18.0),
        ];

        final bosResult = TaxCalculator.calculate(
          invoiceType: InvoiceType.billOfSupply,
          items: items,
          useIgst: true,
        );
        expect(bosResult.cgstAmount, 0.0);
        expect(bosResult.sgstAmount, 0.0);
        expect(bosResult.igstAmount, 0.0);
        expect(bosResult.grandTotal, 1000.0);

        final dcResult = TaxCalculator.calculate(
          invoiceType: InvoiceType.deliveryChallan,
          items: items,
          useIgst: true,
        );
        expect(dcResult.cgstAmount, 0.0);
        expect(dcResult.sgstAmount, 0.0);
        expect(dcResult.igstAmount, 0.0);
        expect(dcResult.grandTotal, 1000.0);
      });
    });
  });
}
