import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/data/repositories/settings_repository.dart';

class InvoiceDetailData {
  final Invoice invoice;
  final List<InvoiceItem> items;
  final Customer customer;
  final CompanySetting companySetting;
  final List<Payment> payments;

  InvoiceDetailData({
    required this.invoice,
    required this.items,
    required this.customer,
    required this.companySetting,
    required this.payments,
  });
}

final invoiceDetailProvider = FutureProvider.family<InvoiceDetailData, int>((ref, invoiceId) async {
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

  return InvoiceDetailData(
    invoice: invoice,
    items: items,
    customer: customer,
    companySetting: settings,
    payments: payments,
  );
});
