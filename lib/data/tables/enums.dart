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
  // ignore: constant_identifier_names
  credit_note,
  // ignore: constant_identifier_names
  debit_note;

  bool get isCreditNote => this == InvoiceType.credit_note;
  bool get isDebitNote => this == InvoiceType.debit_note;
  bool get isNote => isCreditNote || isDebitNote;
}

enum NoteReason {
  // ignore: constant_identifier_names
  sales_return,
  // ignore: constant_identifier_names
  post_sale_discount,
  // ignore: constant_identifier_names
  price_correction,
  // ignore: constant_identifier_names
  quantity_correction,
  // ignore: constant_identifier_names
  additional_charges,
  other;

  String get displayName {
    switch (this) {
      case NoteReason.sales_return:
        return 'Sales Return';
      case NoteReason.post_sale_discount:
        return 'Post-Sale Discount';
      case NoteReason.price_correction:
        return 'Price Correction';
      case NoteReason.quantity_correction:
        return 'Quantity Correction';
      case NoteReason.additional_charges:
        return 'Additional Charges';
      case NoteReason.other:
        return 'Other';
    }
  }
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
  // ignore: constant_identifier_names
  sales_return_in,
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
