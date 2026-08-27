import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';
import 'package:starelectricerp/features/customers/screens/customer_form_dialog.dart';

class CustomersListScreen extends ConsumerWidget {
  const CustomersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersStreamProvider);

    return AppLayout(
      currentRoute: '/customers',
      appBar: AppBar(title: const Text('Customers')),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customers',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                AppButton(
                  label: '+ Add Customer',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CustomerFormDialog(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: customersAsync.when(
                data: (customers) {
                  return AppDataTable<Customer>(
                    columns: const [
                      'Name',
                      'Phone',
                      'GSTIN',
                      'State',
                      'Actions'
                    ],
                    data: customers,
                    searchHint: 'Search customers...',
                    emptyMessage: 'No customers yet — Add your first customer',
                    onSearchChanged: (val) {
                      // Note: We don't have a search provider yet for customers, 
                      // but we can implement local filtering or use AppDataTable's search if we build it.
                    },
                    buildRow: (c) {
                      return [
                        InkWell(
                          onTap: () => _openCustomerDetail(context, c.id),
                          child: Text(
                            c.name,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(c.phone),
                        Text(c.gstin ?? ''),
                        Text(c.state),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            TextButton.icon(
                              onPressed: () => _openCustomerDetail(context, c.id),
                              icon: const Icon(Icons.person, size: 18),
                              label: const Text('Detail'),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push('/customers/${c.id}/ledger'),
                              icon: const Icon(Icons.account_balance_wallet, size: 18),
                              label: const Text('Ledger'),
                            ),
                          ],
                        ),
                      ];
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCustomerDetail(BuildContext context, int customerId) {
    showDialog(
      context: context,
      builder: (context) => CustomerFormDialog(customerId: customerId),
    );
  }
}
