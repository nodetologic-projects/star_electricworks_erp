import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """    if (widget.invoiceId != null) {
      // Note: Edit mode is not currently implemented or routed.
    } else {"""

patch = """    if (widget.invoiceId != null) {
      Future.microtask(() => _loadExistingInvoice(widget.invoiceId!));
    } else {"""

if target not in content:
    print("Target not found or already patched")
    sys.exit(0)

new_content = content.replace(target, patch)

extra_method = """
  Future<void> _loadExistingInvoice(int id) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final custRepo = ref.read(customersRepositoryProvider);
    
    final existingInvoice = await repo.getInvoiceById(id);
    if (existingInvoice == null) return;
    final existingItems = await repo.getItemsForInvoice(id);
    final existingCustomer = await custRepo.getCustomerById(existingInvoice.customerId);
    
    if (mounted) {
      setState(() {
        _selectedType = existingInvoice.invoiceType;
        _selectedCustomer = existingInvoice.customerId;
        _invoiceDate = existingInvoice.invoiceDate;
        _dueDate = existingInvoice.dueDate ?? existingInvoice.invoiceDate;
        _paymentTermDays = existingInvoice.paymentTermDays ?? 0;
        _deliveryCharge = existingInvoice.deliveryCharge ?? 0;
        _discountAmount = existingInvoice.discountAmount;
        _notes = existingInvoice.notes ?? '';
        _isDiscountPercentage = false; // it is stored as absolute amount
        
        if (existingCustomer != null) {
          _customerNameController.text = existingCustomer.name;
          _customerAddressController.text = existingCustomer.address ?? '';
          _customerStateController.text = existingCustomer.state ?? '';
          _customerGstinController.text = existingCustomer.gstin ?? '';
          _customerPhoneController.text = existingCustomer.phone ?? '';
          _customerEmailController.text = existingCustomer.email ?? '';
          _customerVendorCodeController.text = existingCustomer.vendorCode ?? '';
        }
        
        _shipToNameController.text = existingInvoice.shipToName ?? '';
        _shipToAddressController.text = existingInvoice.shipToAddress ?? '';
        _placeOfSupplyController.text = existingInvoice.placeOfSupply ?? '';
        _poNumberController.text = existingInvoice.poNumber ?? '';
        _poDate = existingInvoice.poDate;
        _gpNumberController.text = existingInvoice.gpNumber ?? '';
        
        _items.clear();
        for (final item in existingItems) {
          final line = _LineItem(type: item.itemSourceType);
          line.linkedId = item.itemSourceType == ItemSourceType.motorJob ? item.motorJobId : item.copperStockId;
          line.description = item.description;
          line.hsnCode = item.hsnCode;
          line.qty = item.qty ?? 1.0;
          line.unitPrice = item.unitPrice;
          line.gstRate = item.gstRate;
          _items.add(line);
        }
      });
    }
  }

  void _recalculate() {"""

new_content = new_content.replace("  void _recalculate() {", extra_method)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(new_content)

print("Patched initState")
