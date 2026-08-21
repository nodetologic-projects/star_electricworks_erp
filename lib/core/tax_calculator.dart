import 'package:starelectricerp/data/tables/enums.dart';

class TaxCalculationResult {
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double deliveryCharge;
  final double grandTotal;

  TaxCalculationResult({
    required this.subtotal,
    required this.discountAmount,
    required this.taxableAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.deliveryCharge,
    required this.grandTotal,
  });
}

class InvoiceLineItemInput {
  final double lineTotal; // qty * unitPrice
  final double? gstRate;

  InvoiceLineItemInput({
    required this.lineTotal,
    this.gstRate,
  });
}

class TaxCalculator {
  /// Pure function to calculate taxes and totals.
  /// Standard GST rounding: round grand total to nearest integer.
  static TaxCalculationResult calculate({
    required InvoiceType invoiceType,
    required List<InvoiceLineItemInput> items,
    double discountAmount = 0.0,
    bool isDiscountPercentage = false,
    double deliveryCharge = 0.0,
  }) {
    double subtotal = 0.0;
    
    // 1. Calculate raw subtotal
    for (final item in items) {
      subtotal += item.lineTotal;
    }

    // 2. Apply discount to get overall taxable baseline
    // If discount is percentage, it's applied on the subtotal.
    double actualDiscount = discountAmount;
    if (isDiscountPercentage) {
      actualDiscount = subtotal * (discountAmount / 100.0);
    }
    
    // Ensure discount doesn't exceed subtotal
    if (actualDiscount > subtotal) {
      actualDiscount = subtotal;
    }

    // Taxable amount includes delivery charge (which is generally taxable at the highest rate in the invoice, 
    // but for simplicity here we assume delivery charge is non-taxable or already tax-inclusive unless specified otherwise.
    // Actually, usually delivery charge is added to taxable value. Let's just calculate tax on line items proportionally,
    // or assume delivery charge is a flat addition without its own GST calculation to keep it simple for now).
    // The prompt: "discount toggles", "Delivery charge shown...". We will apply discount proportionally across items for tax, 
    // or just calculate total tax based on the discounted value. 
    // The most accurate way is to calculate tax per line item, subtracting the proportional discount from that line item's taxable value.
    
    double totalCgst = 0.0;
    double totalSgst = 0.0;

    final skipTax = invoiceType == InvoiceType.billOfSupply || invoiceType == InvoiceType.deliveryChallan;

    if (!skipTax && subtotal > 0) {
      final discountFactor = (subtotal - actualDiscount) / subtotal;

      for (final item in items) {
        final lineTaxableValue = item.lineTotal * discountFactor;
        
        if (item.gstRate != null && item.gstRate! > 0) {
          final gstAmount = lineTaxableValue * (item.gstRate! / 100.0);
          // Split GST into CGST and SGST (Gujarat intra-state)
          totalCgst += gstAmount / 2.0;
          totalSgst += gstAmount / 2.0;
        }
      }
    }

    final taxableAmount = subtotal - actualDiscount;
    final rawGrandTotal = taxableAmount + totalCgst + totalSgst + deliveryCharge;
    
    // Round to nearest rupee
    final grandTotal = rawGrandTotal.roundToDouble();

    return TaxCalculationResult(
      subtotal: subtotal,
      discountAmount: actualDiscount,
      taxableAmount: taxableAmount,
      cgstAmount: totalCgst,
      sgstAmount: totalSgst,
      deliveryCharge: deliveryCharge,
      grandTotal: grandTotal,
    );
  }
}
