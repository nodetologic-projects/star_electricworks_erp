import 'package:starelectricerp/data/tables/enums.dart';

class TaxCalculationResult {
  final double subtotal; // Raw subtotal before ANY discounts
  final double itemDiscountAmount; // Sum of all per-item discounts
  final double bundleDiscountAmount; // The overall bundle discount amount (0.0 for new invoices)
  final double discountAmount; // Total discount (item + bundle)
  final double taxableAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final double deliveryCharge;
  final double grandTotal;

  TaxCalculationResult({
    required this.subtotal,
    required this.itemDiscountAmount,
    required this.bundleDiscountAmount,
    required this.discountAmount,
    required this.taxableAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    this.igstAmount = 0.0,
    required this.deliveryCharge,
    required this.grandTotal,
  });
}

class InvoiceLineItemInput {
  final double lineTotal; // qty * unitPrice (pre-discount)
  final double? discountPercent; // per-item discount %
  final double? gstRate;

  InvoiceLineItemInput({
    required this.lineTotal,
    this.discountPercent,
    this.gstRate,
  });

  /// The discount amount for this line item
  double get discountAmount => lineTotal * ((discountPercent ?? 0.0) / 100.0);

  /// Taxable value after per-line discount
  double get taxableAmount => lineTotal - discountAmount;

  /// CGST calculated on post-discount taxable value
  double get cgstAmount =>
      gstRate != null && gstRate! > 0 ? (taxableAmount * (gstRate! / 200.0)) : 0.0;

  /// SGST calculated on post-discount taxable value
  double get sgstAmount =>
      gstRate != null && gstRate! > 0 ? (taxableAmount * (gstRate! / 200.0)) : 0.0;

  /// Total GST for this line
  double get totalGst => cgstAmount + sgstAmount;

  /// Line total including post-discount taxable value and taxes
  double get totalWithTax => taxableAmount + totalGst;
}

class TaxCalculator {
  /// Pure function to calculate taxes and totals.
  static TaxCalculationResult calculate({
    required InvoiceType invoiceType,
    required List<InvoiceLineItemInput> items,
    double bundleDiscountValue = 0.0,
    bool isBundleDiscountPercentage = false,
    bool distributeBundleDiscount = true,
    double deliveryCharge = 0.0,
  }) {
    double rawSubtotal = 0.0;
    double sumItemDiscounts = 0.0;
    double postItemDiscountBaseline = 0.0;
    double totalCgst = 0.0;
    double totalSgst = 0.0;

    final skipTax =
        invoiceType == InvoiceType.billOfSupply || invoiceType == InvoiceType.deliveryChallan;

    for (final item in items) {
      rawSubtotal += item.lineTotal;
      final lineDiscount = item.discountAmount;
      sumItemDiscounts += lineDiscount;
      final lineTaxable = item.taxableAmount;
      postItemDiscountBaseline += lineTaxable;

      if (!skipTax) {
        totalCgst += item.cgstAmount;
        totalSgst += item.sgstAmount;
      }
    }

    // Support legacy bundle discount if provided
    double bundleDiscountAmount = bundleDiscountValue;
    if (bundleDiscountValue > 0) {
      if (isBundleDiscountPercentage) {
        bundleDiscountAmount = postItemDiscountBaseline * (bundleDiscountValue / 100.0);
      }
      if (bundleDiscountAmount > postItemDiscountBaseline) {
        bundleDiscountAmount = postItemDiscountBaseline;
      }
      if (distributeBundleDiscount && postItemDiscountBaseline > 0) {
        final distributionFactor =
            (postItemDiscountBaseline - bundleDiscountAmount) / postItemDiscountBaseline;
        totalCgst = 0.0;
        totalSgst = 0.0;
        if (!skipTax) {
          for (final item in items) {
            final lineTaxable = item.taxableAmount * distributionFactor;
            if (item.gstRate != null && item.gstRate! > 0) {
              final gstAmount = lineTaxable * (item.gstRate! / 100.0);
              totalCgst += gstAmount / 2.0;
              totalSgst += gstAmount / 2.0;
            }
          }
        }
      }
    }

    final totalDiscount = sumItemDiscounts + bundleDiscountAmount;
    final taxableAmount = postItemDiscountBaseline - bundleDiscountAmount;
    final rawGrandTotal = taxableAmount + totalCgst + totalSgst + deliveryCharge;
    final grandTotal = rawGrandTotal.roundToDouble();

    return TaxCalculationResult(
      subtotal: rawSubtotal,
      itemDiscountAmount: sumItemDiscounts,
      bundleDiscountAmount: bundleDiscountAmount,
      discountAmount: totalDiscount,
      taxableAmount: taxableAmount,
      cgstAmount: totalCgst,
      sgstAmount: totalSgst,
      igstAmount: 0.0,
      deliveryCharge: deliveryCharge,
      grandTotal: grandTotal,
    );
  }
}
