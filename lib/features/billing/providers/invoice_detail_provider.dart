import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class InvoiceDetailData {
  final Invoice invoice;
  final List<InvoiceItem> items;
  final Customer customer;
  final CompanySetting companySetting;
  final List<Payment> payments;
  final List<Invoice> creditNotes;
  final List<Invoice> debitNotes;
  final Invoice? originalInvoice;
  final double totalPaid;
  final double totalCreditNotes;
  final double totalDebitNotes;
  final double balanceDue;

  InvoiceDetailData({
    required this.invoice,
    required this.items,
    required this.customer,
    required this.companySetting,
    required this.payments,
    this.creditNotes = const [],
    this.debitNotes = const [],
    this.originalInvoice,
    this.totalPaid = 0.0,
    this.totalCreditNotes = 0.0,
    this.totalDebitNotes = 0.0,
    this.balanceDue = 0.0,
  });
}

final invoiceDetailProvider = FutureProvider.autoDispose.family<InvoiceDetailData, int>((ref, invoiceId) async {
  final invoiceRepo = ref.watch(invoicesRepositoryProvider);
  final customerRepo = ref.watch(customersRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);

  // 1. Fetch Invoice
  final invoice = await invoiceRepo.getInvoiceById(invoiceId);

  // 2. Fetch Items
  final items = await invoiceRepo.getItemsForInvoice(invoiceId);

  // 3. Fetch Customer
  final customer = await customerRepo.getCustomerById(invoice.customerId);

  // 4. Fetch Settings
  final settings = await settingsRepo.getSettings();

  // 5. Fetch Payments
  final payments = await invoiceRepo.getPaymentsForInvoice(invoiceId);

  Invoice? originalInvoice;
  List<Invoice> creditNotes = [];
  List<Invoice> debitNotes = [];
  double totalPaid = payments.fold<double>(0.0, (s, p) => s + p.amount);
  double totalCreditNotes = 0.0;
  double totalDebitNotes = 0.0;
  double balanceDue = invoice.grandTotal - totalPaid;

  if (invoice.invoiceType.isNote) {
    if (invoice.originalInvoiceId != null) {
      originalInvoice = await invoiceRepo.getInvoiceById(invoice.originalInvoiceId!);
    }
  } else {
    final notes = await invoiceRepo.getNotesForInvoice(invoiceId);
    creditNotes = notes.where((n) => n.invoiceType == InvoiceType.credit_note).toList();
    debitNotes = notes.where((n) => n.invoiceType == InvoiceType.debit_note).toList();
    totalCreditNotes = creditNotes.fold<double>(0.0, (s, n) => s + n.grandTotal);
    totalDebitNotes = debitNotes.fold<double>(0.0, (s, n) => s + n.grandTotal);
    balanceDue = invoice.grandTotal + totalDebitNotes - totalCreditNotes - totalPaid;
  }

  return InvoiceDetailData(
    invoice: invoice,
    items: items,
    customer: customer,
    companySetting: settings,
    payments: payments,
    creditNotes: creditNotes,
    debitNotes: debitNotes,
    originalInvoice: originalInvoice,
    totalPaid: totalPaid,
    totalCreditNotes: totalCreditNotes,
    totalDebitNotes: totalDebitNotes,
    balanceDue: balanceDue,
  );
});
