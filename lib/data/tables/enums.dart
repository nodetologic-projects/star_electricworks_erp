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
        return 'CGST + SGST';
      case TaxMode.all_three:
        return 'CGST + SGST + IGST';
      case TaxMode.igst_only:
        return 'IGST only';
    }
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
