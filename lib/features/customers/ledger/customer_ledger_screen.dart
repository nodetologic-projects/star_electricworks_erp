import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/features/customers/providers/ledger_providers.dart';
import 'package:starelectricerp/features/customers/ledger/customer_ledger_export_dialog.dart';

class CustomerLedgerScreen extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends ConsumerState<CustomerLedgerScreen> {
  final bool _includeInvoices = true;
  final bool _includePayments = true;
  final bool _includeCreditDebitNotes = true;
  bool _includeDeliveryChallans = true;
  bool _includeMotorJobs = true;
  bool _includeQuotations = true;
  bool _includePurchaseVouchers = true;

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(customerLedgerProvider(widget.customerId));
    final dateFmt = DateFormat('dd/MM/yyyy');

    return AppLayout(
      currentRoute: '/ledger',
      appBar: AppBar(
        title: const Text('Customer Party Ledger'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => CustomerLedgerExportDialog(customerId: widget.customerId),
                );
              },
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('Export Ledger (PDF)'),
            ),
          ),
        ],
      ),
      child: ledgerAsync.when(
        data: (result) {
          final displayedEntries = result.entries.where((e) {
            switch (e.documentType) {
              case 'Service Tax Invoice':
              case 'Sales Tax Invoice':
              case 'Bill of Supply':
              case 'Invoice':
                return _includeInvoices;
              case 'Payment':
                return _includePayments;
              case 'Credit Note':
              case 'Debit Note':
                return _includeCreditDebitNotes;
              case 'Delivery Challan':
                return _includeDeliveryChallans;
              case 'Motor Job':
                return _includeMotorJobs;
              case 'Quotation':
                return _includeQuotations;
              case 'Purchase Voucher':
                return _includePurchaseVouchers;
              default:
                return true;
            }
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${result.customer.name} - Complete Party Ledger',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CustomerLedgerExportDialog(customerId: widget.customerId),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: const Text('Export Ledger (PDF)'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Summary Cards
                Row(
                  children: [
                    _buildSummaryCard(context, 'Lifetime Billed', result.totalBilled, Colors.blue.shade700),
                    const SizedBox(width: 16),
                    _buildSummaryCard(context, 'Total Received', result.totalPaid, Colors.green.shade700),
                    const SizedBox(width: 16),
                    _buildSummaryCard(context, 'Total Outstanding', result.totalOutstanding, Colors.red.shade700),
                  ],
                ),
                const SizedBox(height: 16),
                // Document Counts Summary Box
                if (result.documentCounts.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          'Document Summary:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        ...result.documentCounts.entries.where((e) => e.value > 0).map(
                          (e) => Chip(
                            visualDensity: VisualDensity.compact,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                            label: Text('${e.value} ${e.key}', style: const TextStyle(fontSize: 11)),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Filter Checkbox Bar
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Filter Rows:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        _buildFilterItem('Invoices & Bills', _includeInvoices, null, isAccounting: true),
                        _buildFilterItem('Payments', _includePayments, null, isAccounting: true),
                        _buildFilterItem('Credit/Debit Notes', _includeCreditDebitNotes, null, isAccounting: true),
                        _buildFilterItem('Delivery Challans', _includeDeliveryChallans, (v) => setState(() => _includeDeliveryChallans = v ?? true)),
                        _buildFilterItem('Motor Jobs', _includeMotorJobs, (v) => setState(() => _includeMotorJobs = v ?? true)),
                        _buildFilterItem('Quotations', _includeQuotations, (v) => setState(() => _includeQuotations = v ?? true)),
                        _buildFilterItem('Purchase Vouchers', _includePurchaseVouchers, (v) => setState(() => _includePurchaseVouchers = v ?? true)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Table
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: displayedEntries.isEmpty
                        ? const Center(child: Text('No records match the selected filters.'))
                        : SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                                columns: const [
                                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Document Type', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Document No', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Debit', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                  DataColumn(label: Text('Credit', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                  DataColumn(label: Text('Balance', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: displayedEntries.map((entry) {
                                  final isRef = entry.isReference;
                                  final textColor = isRef ? Colors.grey.shade600 : Colors.black87;
                                  final rowStyle = TextStyle(color: textColor, fontSize: 13);

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(dateFmt.format(entry.date), style: rowStyle)),
                                      DataCell(Text(entry.documentType, style: rowStyle)),
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            if (entry.navigationRoute != null) {
                                              context.push(entry.navigationRoute!);
                                            }
                                          },
                                          child: Text(
                                            entry.documentNo,
                                            style: rowStyle.copyWith(
                                              color: entry.navigationRoute != null ? Colors.blue.shade700 : textColor,
                                              decoration: entry.navigationRoute != null ? TextDecoration.underline : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 280),
                                          child: Text(
                                            entry.details,
                                            style: rowStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.debit != null && entry.debit! > 0
                                              ? '₹${entry.debit!.toStringAsFixed(2)}'
                                              : '—',
                                          style: rowStyle.copyWith(
                                            fontWeight: entry.debit != null ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.credit != null && entry.credit! > 0
                                              ? '₹${entry.credit!.toStringAsFixed(2)}'
                                              : '—',
                                          style: rowStyle.copyWith(
                                            fontWeight: entry.credit != null ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '₹${entry.runningBalance.toStringAsFixed(2)}',
                                          style: rowStyle.copyWith(
                                            fontWeight: isRef ? FontWeight.normal : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.status ?? '—',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: (entry.status == 'Overdue' || entry.status == 'Unpaid')
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: entry.status == 'Paid'
                                                ? Colors.green.shade700
                                                : (entry.status == 'Overdue'
                                                    ? Colors.red.shade700
                                                    : textColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFilterItem(
    String label,
    bool value,
    ValueChanged<bool?>? onChanged, {
    bool isAccounting = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isAccounting ? FontWeight.w600 : FontWeight.normal,
            color: isAccounting ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        if (isAccounting)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Icon(Icons.lock, size: 12, color: Colors.grey.shade500),
          ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color color) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.withValues(alpha: 0.3))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('₹${amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
