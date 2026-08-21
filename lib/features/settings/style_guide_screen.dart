import 'package:flutter/material.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/confirm_dialog.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/empty_state.dart';

class StyleGuideScreen extends StatefulWidget {
  const StyleGuideScreen({super.key});

  @override
  State<StyleGuideScreen> createState() => _StyleGuideScreenState();
}

class _StyleGuideScreenState extends State<StyleGuideScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Guide & Components'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Buttons'),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  AppButton(label: 'Primary', onPressed: () {}),
                  AppButton(label: 'Secondary', variant: AppButtonVariant.secondary, onPressed: () {}),
                  AppButton(label: 'Danger', variant: AppButtonVariant.danger, onPressed: () {}),
                  AppButton(label: 'Loading', isLoading: true, onPressed: () {}),
                  AppButton(label: 'With Icon', icon: Icons.add, onPressed: () {}),
                ],
              ),
              
              _buildSectionTitle('Inputs & Forms'),
              SizedBox(
                width: 400,
                child: AppTextField(
                  label: 'Product Name',
                  hintText: 'Enter product name',
                  validator: (val) => val == null || val.isEmpty ? 'Product name is required' : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 400,
                child: AppSelect<String>(
                  label: 'Category',
                  hintText: 'Select category',
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Electronics')),
                    DropdownMenuItem(value: '2', child: Text('Cables')),
                  ],
                  onChanged: (val) {},
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Validate Form',
                onPressed: () => _formKey.currentState?.validate(),
              ),

              _buildSectionTitle('Dialogs'),
              AppButton(
                label: 'Show Confirm Dialog',
                onPressed: () {
                  ConfirmDialog.show(
                    context,
                    title: 'Delete Product',
                    content: 'Are you sure you want to delete this product? This action cannot be undone.',
                    isDestructive: true,
                    confirmLabel: 'Delete',
                  );
                },
              ),

              _buildSectionTitle('Status Badges'),
              const Wrap(
                spacing: 16,
                children: [
                  StatusBadge(type: StatusBadgeType.paid),
                  StatusBadge(type: StatusBadgeType.pending),
                  StatusBadge(type: StatusBadgeType.overdue),
                  StatusBadge(type: StatusBadgeType.lowStock),
                ],
              ),

              _buildSectionTitle('Data Table'),
              AppDataTable<Map<String, String>>(
                columns: const ['Invoice ID', 'Customer', 'Amount', 'Status'],
                data: const [
                  {'id': 'INV-001', 'customer': 'Acme Corp', 'amount': '\$1,200', 'status': 'paid'},
                  {'id': 'INV-002', 'customer': 'Globex', 'amount': '\$450', 'status': 'pending'},
                  {'id': 'INV-003', 'customer': 'Initech', 'amount': '\$3,100', 'status': 'overdue'},
                ],
                searchHint: 'Search invoices...',
                onSearchChanged: (val) {},
                buildRow: (item) {
                  StatusBadgeType type;
                  if (item['status'] == 'paid') {
                    type = StatusBadgeType.paid;
                  } else if (item['status'] == 'overdue') {
                    type = StatusBadgeType.overdue;
                  } else {
                    type = StatusBadgeType.pending;
                  }

                  return [
                    Text(item['id']!),
                    Text(item['customer']!),
                    Text(item['amount']!),
                    StatusBadge(type: type),
                  ];
                },
              ),

              _buildSectionTitle('Empty State'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 400,
                child: EmptyState(
                  title: 'No invoices yet',
                  message: 'Create your first invoice to start getting paid.',
                  actionLabel: 'Create Invoice',
                  onActionPressed: () {},
                  icon: Icons.receipt_long,
                ),
              ),
              const SizedBox(height: 64), // bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 24),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
