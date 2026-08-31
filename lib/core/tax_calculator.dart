import 'package:starelectricerp/data/tables/enums.dart';

class TaxCalculationResult {
  final double subtotal; // Raw subtotal before ANY discounts
  final double itemDiscountAmount; // Sum of all per-item discounts
  final double bundleDiscountAmount; // The overall bundle discount amount
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
}

class TaxCalculator {
  /// Pure function to calculate taxes and totals with compounded discounts.
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

    // 1. Calculate item-level reductions
    for (final item in items) {
      rawSubtotal += item.lineTotal;
      final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
      sumItemDiscounts += itemDiscount;
      postItemDiscountBaseline += (item.lineTotal - itemDiscount);
    }

    // 2. Calculate bundle discount (applied on the post-item-discount baseline)
    double bundleDiscountAmount = bundleDiscountValue;
    if (isBundleDiscountPercentage) {
      bundleDiscountAmount = postItemDiscountBaseline * (bundleDiscountValue / 100.0);
    }
    
    if (bundleDiscountAmount > postItemDiscountBaseline) {
      bundleDiscountAmount = postItemDiscountBaseline;
    }

    double totalDiscount = sumItemDiscounts + bundleDiscountAmount;

    // 3. Tax Calculation
    double totalCgst = 0.0;
    double totalSgst = 0.0;
    final skipTax = invoiceType == InvoiceType.billOfSupply || invoiceType == InvoiceType.deliveryChallan;

    if (!skipTax && postItemDiscountBaseline > 0) {
      // If distribute is TRUE, GST is calculated on the remaining value after the bundle discount is stripped.
      // If distribute is FALSE, GST is calculated on the post-item-discount baseline directly.
      final distributionFactor = distributeBundleDiscount 
          ? (postItemDiscountBaseline - bundleDiscountAmount) / postItemDiscountBaseline 
          : 1.0;

      for (final item in items) {
        final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
        final itemPostDiscount = item.lineTotal - itemDiscount;
        final finalTaxableValue = itemPostDiscount * distributionFactor;
        
        if (item.gstRate != null && item.gstRate! > 0) {
          final gstAmount = finalTaxableValue * (item.gstRate! / 100.0);
          totalCgst += gstAmount / 2.0;
          totalSgst += gstAmount / 2.0;
        }
      }
    }

    final taxableAmount = postItemDiscountBaseline - bundleDiscountAmount;
    // Note: taxableAmount is just for display summary. 
    // If distribute is false, the GST was calculated on a LARGER amount than this taxableAmount, 
    // but the grand total still subtracts the bundle discount at the bottom line.
    final rawGrandTotal = taxableAmount + totalCgst + totalSgst + deliveryCharge;
    
    // Round to nearest rupee
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
