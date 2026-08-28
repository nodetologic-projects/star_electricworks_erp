import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/reports/utils/excel_export.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/features/reports/screens/ca_export_tab.dart';

// State managed internally by StatefulWidget

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: AppLayout(
        currentRoute: '/reports',
        appBar: AppBar(
          title: const Text('Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sales Report'),
              Tab(text: 'Stock Report'),
              Tab(text: 'GST Summary'),
              Tab(text: 'CA Export'),
            ],
          ),
        ),
        child: const TabBarView(
          children: [
            _SalesReportTab(),
            _StockReportTab(),
            _GstSummaryTab(),
            CaExportTab(),
          ],
        ),
      ),
    );
  }
}

class _SalesReportTab extends ConsumerStatefulWidget {
  const _SalesReportTab();

  @override
  ConsumerState<_SalesReportTab> createState() => _SalesReportTabState();
}

class _SalesReportTabState extends ConsumerState<_SalesReportTab> {
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(invoicesRepositoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text('Date Range: ${DateFormat('dd MMM yyyy').format(dateRange.start)} - ${DateFormat('dd MMM yyyy').format(dateRange.end)}'),
              const SizedBox(width: 16),
              AppButton(
                label: 'Change Dates',
                onPressed: () async {
                  final result = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDateRange: dateRange,
                  );
                  if (result != null) {
                    setState(() {
                      dateRange = result;
                    });
                  }
                },
                variant: AppButtonVariant.secondary,
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<InvoiceWithCustomer>>(
            future: repo.getInvoicesByDateRange(dateRange.start, dateRange.end),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

              final invoices = snapshot.data ?? [];
              double totalSales = 0;
              double totalGst = 0;
              for (var i in invoices) {
                totalSales += i.invoice.grandTotal;
                totalGst += i.invoice.cgstAmount + i.invoice.sgstAmount;
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Invoice No')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Taxable Amt')),
                          DataColumn(label: Text('GST')),
                          DataColumn(label: Text('Grand Total')),
                        ],
                        rows: invoices.map((i) {
                          return DataRow(cells: [
                            DataCell(Text(DateFormat('dd-MMM-yyyy').format(i.invoice.invoiceDate))),
                            DataCell(Text(i.invoice.invoiceNo)),
                            DataCell(Text(i.customer.name)),
                            DataCell(Text('₹${i.invoice.subtotal.toStringAsFixed(2)}')),
                            DataCell(Text('₹${(i.invoice.cgstAmount + i.invoice.sgstAmount).toStringAsFixed(2)}')),
                            DataCell(Text('₹${i.invoice.grandTotal.toStringAsFixed(2)}')),
                          ]);
                        }).toList(),
                      ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Sales: ₹${totalSales.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Total GST: ₹${totalGst.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        AppButton(
                          label: 'Export to Excel',
                          onPressed: () async {
                            final rows = [
                              ['Date', 'Invoice No', 'Customer', 'Taxable Amt', 'GST', 'Grand Total'],
                              ...invoices.map((i) => [
                                DateFormat('dd-MMM-yyyy').format(i.invoice.invoiceDate),
                                i.invoice.invoiceNo,
                                i.customer.name,
                                i.invoice.subtotal,
                                i.invoice.cgstAmount + i.invoice.sgstAmount,
                                i.invoice.grandTotal,
                              ]),
                              [],
                              ['Total', '', '', '', totalGst, totalSales]
                            ];
try {
                            final path = await ExcelExport.exportData('Sales_Report', rows);
                            if (path != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to $path')));
                            }
                            } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StockReportTab extends ConsumerStatefulWidget {
  const _StockReportTab();

  @override
  ConsumerState<_StockReportTab> createState() => _StockReportTabState();
}

class _StockReportTabState extends ConsumerState<_StockReportTab> {
  bool showLowStock = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(copperStockRepositoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Switch(
                value: showLowStock,
                onChanged: (val) {
                  setState(() {
                    showLowStock = val;
                  });
                },
              ),
              const Text('Show Low Stock Only'),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<CopperStockData>>(
            future: showLowStock ? repo.getLowStockItems() : repo.getAllCopperStock(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

              final stock = snapshot.data ?? [];

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Current Qty (Kg)')),
                          DataColumn(label: Text('Reorder Level (Kg)')),
                        ],
                        rows: stock.map((s) {
                          final isLow = s.reorderLevelKg != null && s.stockQtyKg <= s.reorderLevelKg!;
                          return DataRow(
                            color: isLow ? WidgetStateProperty.all(Colors.red.shade50) : null,
                            cells: [
                              DataCell(Text(s.copperType.name)),
                              DataCell(Text(s.description)),
                              DataCell(Text(s.stockQtyKg.toStringAsFixed(2))),
                              DataCell(Text(s.reorderLevelKg?.toStringAsFixed(2) ?? 'N/A')),
                            ],
                          );
                        }).toList(),
                      ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          label: 'Export to Excel',
                          onPressed: () async {
                            final rows = [
                              ['Type', 'Description', 'Current Qty (Kg)', 'Reorder Level (Kg)'],
                              ...stock.map((s) => [
                                s.copperType.name,
                                s.description,
                                s.stockQtyKg,
                                s.reorderLevelKg ?? '',
                              ]),
                            ];
try {
                            final path = await ExcelExport.exportData('Stock_Report', rows);
                            if (path != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to $path')));
                            }
                            } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GstSummaryTab extends ConsumerWidget {
  const _GstSummaryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(invoicesRepositoryProvider);

    return FutureBuilder<List<GstSummaryRow>>(
      future: repo.getGstSummaryByMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        final summaries = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Month')),
                    DataColumn(label: Text('Total Sales')),
                    DataColumn(label: Text('CGST')),
                    DataColumn(label: Text('SGST')),
                    DataColumn(label: Text('IGST')),
                  ],
                  rows: summaries.map((s) {
                    return DataRow(cells: [
                      DataCell(Text(s.month)),
                      DataCell(Text('₹${s.totalSales.toStringAsFixed(2)}')),
                      DataCell(Text('₹${s.cgst.toStringAsFixed(2)}')),
                      DataCell(Text('₹${s.sgst.toStringAsFixed(2)}')),
                      DataCell(Text('₹${s.igst.toStringAsFixed(2)}')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
                  ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Export to Excel',
                    onPressed: () async {
                      final rows = [
                        ['Month', 'Total Sales', 'CGST', 'SGST', 'IGST'],
                        ...summaries.map((s) => [
                          s.month,
                          s.totalSales,
                          s.cgst,
                          s.sgst,
                          s.igst,
                        ]),
                      ];
try {
                      final path = await ExcelExport.exportData('GST_Summary', rows);
                      if (path != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to $path')));
                      }
                      } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
