import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/cashbook_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/features/cashbook/screens/add_transaction_dialog.dart';
import 'package:starelectricerp/features/reports/utils/excel_export.dart';

class CashbookScreen extends ConsumerStatefulWidget {
  const CashbookScreen({super.key});

  @override
  ConsumerState<CashbookScreen> createState() => _CashbookScreenState();
}

class _CashbookScreenState extends ConsumerState<CashbookScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String? _selectedCategory;

  Future<void> _exportToExcel(List<CashTransaction> transactions) async {
    final rows = <List<dynamic>>[];
    
    // Header
    rows.add(['Date', 'Type', 'Category', 'Description', 'Amount']);
    
    // Data
    for (final t in transactions) {
      rows.add([
        DateFormat('dd/MM/yyyy').format(t.transactionDate),
        t.transactionType.name.toUpperCase(),
        t.category,
        t.description ?? '',
        t.amount,
      ]);
    }
    
    try {
      final path = await ExcelExport.exportData('CashBook_Report', rows);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to: $path')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(cashbookRepositoryProvider);

    return AppLayout(
      currentRoute: '/cashbook',
      appBar: AppBar(
        title: const Text('Cash Book'),
        actions: [
          AppButton(
            onPressed: () async {
              final added = await showDialog<bool>(
                context: context,
                builder: (context) => const AddTransactionDialog(),
              );
              if (added == true) {
                setState(() {}); // refresh
              }
            },
            label: 'Add Transaction',
            icon: Icons.add,
          ),
          const SizedBox(width: 16),
        ],
      ),
      child: Column(
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.amber.shade100,
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cash book entries are for internal tracking only and are not linked to GST invoices.',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
          
          // Filters & Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Date Range
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final res = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                            );
                            if (res != null) {
                              setState(() {
                                _startDate = res.start;
                                _endDate = res.end;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text('${DateFormat('dd/MM/yyyy').format(_startDate)} - ${DateFormat('dd/MM/yyyy').format(_endDate)}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    
                    // Category Filter
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<CashCategory>>(
                        future: repo.getCategories(),
                        builder: (context, snapshot) {
                          final cats = snapshot.data ?? [];
                          return AppSelect<String?>(
                            label: 'Category',
                            value: _selectedCategory,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All')),
                              ...cats.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))),
                            ],
                            onChanged: (val) {
                              setState(() => _selectedCategory = val);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                // Summary Card
                FutureBuilder<Map<String, double>>(
                  future: repo.getSummary(startDate: _startDate, endDate: _endDate, category: _selectedCategory),
                  builder: (context, snapshot) {
                    final summary = snapshot.data ?? {'totalIncome': 0.0, 'totalExpense': 0.0, 'netBalance': 0.0};
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSummaryBox('Income', summary['totalIncome']!, Colors.green),
                        const SizedBox(width: 8),
                        _buildSummaryBox('Expense', summary['totalExpense']!, Colors.red),
                        const SizedBox(width: 8),
                        _buildSummaryBox('Net', summary['netBalance']!, summary['netBalance']! >= 0 ? Colors.blue : Colors.red),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // List
          Expanded(
            child: FutureBuilder<List<CashTransaction>>(
              future: repo.getTransactions(startDate: _startDate, endDate: _endDate, category: _selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final transactions = snapshot.data ?? [];
                
                if (transactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextButton.icon(
                          onPressed: () => _exportToExcel(transactions),
                          icon: const Icon(Icons.file_download),
                          label: const Text('Export to Excel'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: transactions.length,
                        separatorBuilder: (c, i) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          final isIncome = t.transactionType == CashTransactionType.income;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                              child: Icon(
                                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(t.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${DateFormat('dd MMM yyyy').format(t.transactionDate)}${t.description != null ? ' - ${t.description}' : ''}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${isIncome ? '+' : '-'} ₹${t.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isIncome ? Colors.green : Colors.red,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Transaction'),
                                        content: const Text('Are you sure you want to delete this transaction?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await repo.deleteTransaction(t.id);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
