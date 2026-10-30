import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class InvoiceFilter {
  final String query;
  final InvoiceType? type;
  final bool notesOnly;

  InvoiceFilter({this.query = '', this.type, this.notesOnly = false});

  InvoiceFilter copyWith({String? query, InvoiceType? type, bool? notesOnly}) {
    return InvoiceFilter(
      query: query ?? this.query,
      type: type,
      notesOnly: notesOnly ?? this.notesOnly,
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
    state = InvoiceFilter(query: state.query, type: type, notesOnly: false);
  }

  void updateNotesOnly(bool notesOnly) {
    state = InvoiceFilter(query: state.query, type: null, notesOnly: notesOnly);
  }
}

final invoiceFilterProvider = NotifierProvider<InvoiceFilterNotifier, InvoiceFilter>(InvoiceFilterNotifier.new);

final filteredInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  final filter = ref.watch(invoiceFilterProvider);
  final repo = ref.watch(invoicesRepositoryProvider);
  
  return repo.watchFilteredInvoices(query: filter.query, type: filter.type, notesOnly: filter.notesOnly);
});
