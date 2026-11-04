import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/data/tables/enums.dart';

/// Single unified status derivation result for an invoice.
class DerivedInvoiceStatus {
  final InvoiceStatus status;
  final String statusLabel; // 'Paid', 'Partially Paid', 'Overdue', 'Pending'
  final double balanceDue;
  final double effectiveTotal;
  final double totalPaid;
  final double totalCreditNotes;
  final double totalDebitNotes;

  const DerivedInvoiceStatus({
    required this.status,
    required this.statusLabel,
    required this.balanceDue,
    required this.effectiveTotal,
    required this.totalPaid,
    required this.totalCreditNotes,
    required this.totalDebitNotes,
  });

  @override
  String toString() =>
      'DerivedInvoiceStatus(status: $status, label: $statusLabel, balanceDue: $balanceDue, effectiveTotal: $effectiveTotal, totalPaid: $totalPaid)';
}

/// Convert rupee amount to integer paise to eliminate floating point drift.
int toPaise(double amount) => (amount * 100.0).round();

/// Derives the status and balance of an invoice from the numbers in integer paise:
/// balanceDue = grandTotal + debit notes - credit notes - sum(payments).
///
/// Rules:
/// - balanceDue <= 0 -> Paid
/// - 0 < paid < total -> Partially Paid (also when credit notes reduce balance partially)
/// - no payment and past due date -> Overdue
/// - otherwise -> Pending (retaining sent status if signed/sent, or draft)
DerivedInvoiceStatus deriveInvoiceStatus({
  required double grandTotal,
  required double totalPaid,
  double totalCreditNotes = 0.0,
  double totalDebitNotes = 0.0,
  DateTime? dueDate,
  DateTime? asOfDate,
  InvoiceStatus? currentStatus,
  bool hasSignedPdf = false,
}) {
  final grandTotalPaise = toPaise(grandTotal);
  final debitNotesPaise = toPaise(totalDebitNotes);
  final creditNotesPaise = toPaise(totalCreditNotes);
  final paidPaise = toPaise(totalPaid);

  final effectiveTotalPaise = grandTotalPaise + debitNotesPaise - creditNotesPaise;
  final balanceDuePaise = effectiveTotalPaise - paidPaise;

  final balanceDue = balanceDuePaise <= 0 ? 0.0 : (balanceDuePaise / 100.0);
  final effectiveTotal = effectiveTotalPaise <= 0 ? 0.0 : (effectiveTotalPaise / 100.0);

  final now = asOfDate ?? IstDateUtils.nowIst();
  final isPastDue = dueDate != null &&
      IstDateUtils.toMidnightIst(dueDate).isBefore(IstDateUtils.toMidnightIst(now));

  InvoiceStatus derivedStatus;
  String statusLabel;

  if (balanceDuePaise <= 0) {
    derivedStatus = InvoiceStatus.paid;
    statusLabel = 'Paid';
  } else if (paidPaise > 0 || creditNotesPaise > 0) {
    derivedStatus = InvoiceStatus.partiallyPaid;
    statusLabel = 'Partially Paid';
  } else if (isPastDue) {
    derivedStatus = InvoiceStatus.overdue;
    statusLabel = 'Overdue';
  } else {
    // Pending
    derivedStatus = (currentStatus == InvoiceStatus.sent || hasSignedPdf)
        ? InvoiceStatus.sent
        : InvoiceStatus.draft;
    statusLabel = 'Pending';
  }

  return DerivedInvoiceStatus(
    status: derivedStatus,
    statusLabel: statusLabel,
    balanceDue: balanceDue,
    effectiveTotal: effectiveTotal,
    totalPaid: totalPaid,
    totalCreditNotes: totalCreditNotes,
    totalDebitNotes: totalDebitNotes,
  );
}
