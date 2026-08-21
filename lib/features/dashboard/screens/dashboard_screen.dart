import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/features/dashboard/providers/dashboard_provider.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardDataProvider);

    return AppLayout(
      currentRoute: '/dashboard',
      appBar: AppBar(title: const Text('Dashboard')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
          ),
          Expanded(
            child: dashboardState.when(
              data: (data) => _buildBody(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardData data) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2, locale: 'en_IN');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Low Stock Alert
          if (data.lowStockItems.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Low Stock Alert', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                        Text('${data.lowStockItems.length} copper items are at or below reorder level.'),
                      ],
                    ),
                  ),
                  AppButton(
                    label: 'View Stock',
                    onPressed: () => context.go('/stock'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: AppButton(
                  label: '+ New Invoice',
                  onPressed: () => context.go('/invoices/new'),
                  variant: AppButtonVariant.primary,
                ),
              ),
              SizedBox(
                width: 200,
                child: AppButton(
                  label: '+ Adjust Stock',
                  onPressed: () => context.go('/stock'),
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stat Cards
          LayoutBuilder(builder: (context, constraints) {
            final double cardWidth = constraints.maxWidth < 600 ? constraints.maxWidth : (constraints.maxWidth - 48) / 4;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildStatCard(
                    title: 'Total Sales (Month)',
                    value: currencyFormat.format(data.stats['totalSales']),
                    icon: Icons.currency_rupee,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildStatCard(
                    title: 'Pending Invoices',
                    value: '${data.stats['pendingCount']} (${currencyFormat.format(data.stats['pendingAmount'])})',
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildStatCard(
                    title: 'GST Collected (Month)',
                    value: currencyFormat.format(data.stats['gstCollected']),
                    icon: Icons.account_balance,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildStatCard(
                    title: 'Low Stock Items',
                    value: data.lowStockItems.length.toString(),
                    icon: Icons.inventory,
                    color: data.lowStockItems.isNotEmpty ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 32),

          // Recent Invoices
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Invoices', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => context.go('/invoices'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (data.recentInvoices.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('No invoices found.', style: TextStyle(color: Colors.grey))),
            )
          else
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.recentInvoices.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = data.recentInvoices[index];
                  final invoice = item.invoice;
                  final customer = item.customer;
                  return ListTile(
                    title: Text('${invoice.invoiceNo} - ${customer.name}'),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(invoice.invoiceDate)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currencyFormat.format(invoice.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold).mono),
                        const SizedBox(width: 16),
                        StatusBadge(type: _mapStatus(invoice.status)),
                      ],
                    ),
                    onTap: () => context.go('/invoices/${invoice.id}'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required MaterialColor color}) {
    return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
      ),
    );
  }

  StatusBadgeType _mapStatus(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
      case InvoiceStatus.sent:
        return StatusBadgeType.pending;
      case InvoiceStatus.paid:
      case InvoiceStatus.delivered:
        return StatusBadgeType.paid;
      case InvoiceStatus.partiallyPaid:
        return StatusBadgeType.partiallyPaid;
      case InvoiceStatus.overdue:
        return StatusBadgeType.overdue;
    }
  }
}
