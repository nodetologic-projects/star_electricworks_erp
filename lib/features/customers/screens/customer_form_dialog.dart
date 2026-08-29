import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/database.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  final int? customerId;

  const CustomerFormDialog({super.key, this.customerId});

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _stateController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _gstinController;
  late TextEditingController _panController;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _stateController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _gstinController = TextEditingController();
    _panController = TextEditingController();
    
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    if (widget.customerId != null) {
      final repo = ref.read(customersRepositoryProvider);
      final customer = await repo.getCustomerById(widget.customerId!);
      if (mounted) {
        _nameController.text = customer.name;
        _addressController.text = customer.address;
        _stateController.text = customer.state;
        _phoneController.text = customer.phone;
        _emailController.text = customer.email;
        _gstinController.text = customer.gstin ?? '';
        _panController.text = customer.panNumber ?? '';
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(customersRepositoryProvider);
      
      final companion = CustomersCompanion(
        name: drift.Value(_nameController.text.trim()),
        address: drift.Value(_addressController.text.trim()),
        state: drift.Value(_stateController.text.trim()),
        phone: drift.Value(_phoneController.text.trim()),
        email: drift.Value(_emailController.text.trim()),
        gstin: drift.Value(_gstinController.text.trim()),
        panNumber: drift.Value(_panController.text.trim()),
      );

      if (widget.customerId == null) {
        await repo.insertCustomer(companion);
      } else {
        await repo.updateCustomer(companion.copyWith(id: drift.Value(widget.customerId!)));
      }
      
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const AlertDialog(content: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())));

    return AlertDialog(
      title: Text(widget.customerId == null ? 'Add Customer' : 'Customer Detail'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gstinController,
                decoration: const InputDecoration(labelText: 'GSTIN', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State *', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address *', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
        FilledButton(onPressed: _save, child: const Text('SAVE')),
      ],
    );
  }
}
