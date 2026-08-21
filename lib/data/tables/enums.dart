enum Phase {
  single,
  three,
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
