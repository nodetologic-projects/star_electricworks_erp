import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

// Removed invoicesStreamProvider because it's no longer used directly.

class InvoiceFilter {
  final String query;
  final InvoiceType? type;

  InvoiceFilter({this.query = '', this.type});

  InvoiceFilter copyWith({String? query, InvoiceType? type}) {
    return InvoiceFilter(
      query: query ?? this.query,
      type: type ?? this.type,
    );
  }
}

class InvoiceFilterNotifier extends Notifier<InvoiceFilter> {
  @override
  InvoiceFilter build() => InvoiceFilter();

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateType(InvoiceType? type) {
    state = InvoiceFilter(query: state.query, type: type);
  }
}

final invoiceFilterProvider = NotifierProvider<InvoiceFilterNotifier, InvoiceFilter>(InvoiceFilterNotifier.new);

final filteredInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  final filter = ref.watch(invoiceFilterProvider);
  final repo = ref.watch(invoicesRepositoryProvider);
  
  return repo.watchFilteredInvoices(query: filter.query, type: filter.type);
});
