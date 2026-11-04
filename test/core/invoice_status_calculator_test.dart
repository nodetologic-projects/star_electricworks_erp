import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/invoice_status_calculator.dart';
import 'package:starelectricerp/data/tables/enums.dart';

void main() {
  group('InvoiceStatusCalculator deriveInvoiceStatus', () {
    test('Unpaid invoice before due date is Pending (draft or sent if signed)', () {
      final res1 = deriveInvoiceStatus(
        grandTotal: 1000.0,
        totalPaid: 0.0,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        currentStatus: InvoiceStatus.draft,
      );
      expect(res1.status, InvoiceStatus.draft);
      expect(res1.statusLabel, 'Pending');
      expect(res1.balanceDue, 1000.0);

      // If signed, status is sent (Pending)
      final res2 = deriveInvoiceStatus(
        grandTotal: 1000.0,
        totalPaid: 0.0,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        hasSignedPdf: true,
      );
      expect(res2.status, InvoiceStatus.sent);
      expect(res2.statusLabel, 'Pending');
    });

    test('Unpaid invoice past due date is Overdue', () {
      final res = deriveInvoiceStatus(
        grandTotal: 1500.0,
        totalPaid: 0.0,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(res.status, InvoiceStatus.overdue);
      expect(res.statusLabel, 'Overdue');
      expect(res.balanceDue, 1500.0);
    });

    test('Exact payment changes status to Paid and balanceDue to 0.0', () {
      final res = deriveInvoiceStatus(
        grandTotal: 4720.0,
        totalPaid: 4720.0,
      );
      expect(res.status, InvoiceStatus.paid);
      expect(res.statusLabel, 'Paid');
      expect(res.balanceDue, 0.0);
    });

    test('Partial payment sets status to Partially Paid with correct balanceDue', () {
      final res = deriveInvoiceStatus(
        grandTotal: 5000.0,
        totalPaid: 2000.0,
      );
      expect(res.status, InvoiceStatus.partiallyPaid);
      expect(res.statusLabel, 'Partially Paid');
      expect(res.balanceDue, 3000.0);
    });

    test('Partial payment past due date stays Partially Paid', () {
      final res = deriveInvoiceStatus(
        grandTotal: 5000.0,
        totalPaid: 2000.0,
        dueDate: DateTime.now().subtract(const Duration(days: 10)),
      );
      expect(res.status, InvoiceStatus.partiallyPaid);
      expect(res.balanceDue, 3000.0);
    });

    test('Over-payment sets status to Paid and balanceDue clamped to 0.0', () {
      final res = deriveInvoiceStatus(
        grandTotal: 1000.0,
        totalPaid: 1050.0,
      );
      expect(res.status, InvoiceStatus.paid);
      expect(res.statusLabel, 'Paid');
      expect(res.balanceDue, 0.0);
    });

    test('Floating-point drift with discount and Rounded Off handles cleanly in paise', () {
      // 3539.999999 vs 3540.00
      final res = deriveInvoiceStatus(
        grandTotal: 3539.999999,
        totalPaid: 3540.00,
      );
      expect(res.status, InvoiceStatus.paid);
      expect(res.balanceDue, 0.0);

      // 0.01 rounded off
      final res2 = deriveInvoiceStatus(
        grandTotal: 1250.00,
        totalPaid: 1249.999999,
      );
      // toPaise(1250.00) = 125000, toPaise(1249.999999) = 125000
      expect(res2.status, InvoiceStatus.paid);
      expect(res2.balanceDue, 0.0);
    });

    test('Credit notes reduce balance and can mark invoice as Paid or Partially Paid', () {
      // Partial credit note
      final resPartial = deriveInvoiceStatus(
        grandTotal: 10000.0,
        totalPaid: 0.0,
        totalCreditNotes: 3000.0,
      );
      expect(resPartial.status, InvoiceStatus.partiallyPaid);
      expect(resPartial.balanceDue, 7000.0);
      expect(resPartial.effectiveTotal, 7000.0);

      // Full credit note
      final resFull = deriveInvoiceStatus(
        grandTotal: 10000.0,
        totalPaid: 0.0,
        totalCreditNotes: 10000.0,
      );
      expect(resFull.status, InvoiceStatus.paid);
      expect(resFull.balanceDue, 0.0);
      expect(resFull.effectiveTotal, 0.0);

      // Credit note + payment equals total
      final resCombo = deriveInvoiceStatus(
        grandTotal: 10000.0,
        totalPaid: 6000.0,
        totalCreditNotes: 4000.0,
      );
      expect(resCombo.status, InvoiceStatus.paid);
      expect(resCombo.balanceDue, 0.0);
    });

    test('Debit notes increase balance and require full payment', () {
      final resDebit = deriveInvoiceStatus(
        grandTotal: 10000.0,
        totalPaid: 10000.0,
        totalDebitNotes: 2000.0,
      );
      // Even though paid grandTotal, debit note made balance 2000.0
      expect(resDebit.status, InvoiceStatus.partiallyPaid);
      expect(resDebit.balanceDue, 2000.0);
      expect(resDebit.effectiveTotal, 12000.0);

      // Full payment covering debit note
      final resDebitPaid = deriveInvoiceStatus(
        grandTotal: 10000.0,
        totalPaid: 12000.0,
        totalDebitNotes: 2000.0,
      );
      expect(resDebitPaid.status, InvoiceStatus.paid);
      expect(resDebitPaid.balanceDue, 0.0);
    });
  });
}
