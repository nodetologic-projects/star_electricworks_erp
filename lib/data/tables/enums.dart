enum Phase {
  single,
  three,
}

enum TaxMode {
  // ignore: constant_identifier_names
  cgst_sgst,
  // ignore: constant_identifier_names
  all_three,
  // ignore: constant_identifier_names
  igst_only;

  String get displayName {
    switch (this) {
      case TaxMode.cgst_sgst:
      case TaxMode.all_three:
        return 'CGST + SGST';
      case TaxMode.igst_only:
        return 'IGST';
    }
  }

  /// Builds a dynamic label showing the GST rate, e.g. "CGST 9% + SGST 9%" and "IGST 18%".
  /// If singleRate is null or lines have mixed rates, returns generic "CGST + SGST" and "IGST".
  String getLabel(double? singleRate) {
    if (singleRate != null && singleRate > 0) {
      final rateStr = '${singleRate.toStringAsFixed(1).replaceAll('.0', '')}%';
      final halfRateStr = '${(singleRate / 2.0).toStringAsFixed(1).replaceAll('.0', '')}%';
      switch (this) {
        case TaxMode.cgst_sgst:
        case TaxMode.all_three:
          return 'CGST $halfRateStr + SGST $halfRateStr';
        case TaxMode.igst_only:
          return 'IGST $rateStr';
      }
    }
    return displayName;
  }
}

enum MotorJobStatus {
  received,
  inProgress,
  rewound,
  dispatched,
}

enum CopperType {
  newCopper,
  oldCopper,
}

enum InvoiceType {
  serviceTaxInvoice,
  salesTaxInvoice,
  billOfSupply,
  purchaseVoucher,
  deliveryChallan,
}

enum InvoiceStatus {
  draft,
  sent,
  partiallyPaid,
  paid,
  overdue,
  delivered,
}

enum QuotationStatus {
  draft,
  sent,
  accepted,
  rejected,
  expired,
  converted,
}

enum PaymentMode {
  cash,
  bankTransfer,
  upi,
  cheque,
}

enum ItemSourceType {
  motorJob,
  copperStock,
  custom,
}

enum MovementType {
  purchaseIn,
  saleOut,
  adjustment,
}

enum DscSigningMethod {
  fileBased,
  usbToken,
}

enum AttendanceStatus {
  present,
  absent,
  halfDay,
  leave,
}

enum CashTransactionType {
  income,
  expense,
}
