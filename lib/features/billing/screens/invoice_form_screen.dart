import 'package:drift/drift.dart' as drift;
import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/data/repositories/quotations_repository.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';
import 'package:starelectricerp/data/repositories/customers_repository.dart';
import 'package:starelectricerp/features/copper_stock/providers/copper_stock_provider.dart';
import 'package:starelectricerp/features/motor_jobs/providers/motor_jobs_provider.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_select.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/rich_text_input.dart';
import 'package:starelectricerp/core/widgets/gstin_input_field.dart';
import 'package:starelectricerp/core/tax_calculator.dart';
import 'package:starelectricerp/core/number_to_words.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

class _LineItem {
  ItemSourceType type;
  int? linkedId;
  String description = '';
  TextEditingController? descController;
  String? hsnCode;
  double qty = 1;
  double unitPrice = 0;
  double? discountPercent;
  double? gstRate;

  _LineItem({required this.type});

  double get lineTotal => qty * unitPrice;
}

class InvoiceFormScreen extends ConsumerStatefulWidget {
  final int? invoiceId;
  final int? prefillJobId;
  final InvoiceType? prefillType;
  final int? prefillCustomerId;
  final int? sourceQuotationId;
  final String? prefillDescription;
  final double? prefillAmount;

  const InvoiceFormScreen({
    super.key,
    this.invoiceId,
    this.prefillJobId,
    this.prefillType,
    this.prefillCustomerId,
    this.sourceQuotationId,
    this.prefillDescription,
    this.prefillAmount,
  });

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  late InvoiceType _selectedType;
  int? _selectedCustomer;
  final TextEditingController _invoiceNoController = TextEditingController();
  bool _isInvoiceNoManuallyEdited = false;
  bool _isInvoiceNoEditable = true;
  bool _isLoadingInvoiceNo = false;

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerAddressController =
      TextEditingController();
  final TextEditingController _customerStateController =
      TextEditingController();
  final TextEditingController _customerGstinController =
      TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _customerVendorCodeController =
      TextEditingController();
  final TextEditingController _shipToNameController = TextEditingController();
  final TextEditingController _shipToAddressController =
      TextEditingController();
  final TextEditingController _placeOfSupplyController =
      TextEditingController();

  final TextEditingController _poNumberController = TextEditingController();
  final TextEditingController _gpNumberController = TextEditingController();
  DateTime? _poDate;
  DateTime? _gpDate;
  DateTime _invoiceDate = DateTime.now();
  DateTime? _dueDate;
  int? _paymentTermDays;
  final List<_LineItem> _items = [];
  String _notes = '';

  double _discountAmount = 0;
  bool _isDiscountPercentage = false;
  bool _distributeDiscountAcrossItems = true;
  final _discountController = TextEditingController(text: '0');
  double _deliveryCharge = 0;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.prefillType ?? InvoiceType.serviceTaxInvoice;
    _selectedCustomer = widget.prefillCustomerId;

    if (widget.invoiceId != null) {
      _isInvoiceNoManuallyEdited = true;
      Future.microtask(() => _loadExistingInvoice(widget.invoiceId!));
    } else {
      _fetchNextInvoiceNumber();
      if (widget.prefillJobId != null) {
        // We prepopulate later when async data loads, for now just add a row
        final item = _LineItem(type: ItemSourceType.motorJob)
            ..linkedId = widget.prefillJobId;
        item.descController = TextEditingController(text: item.description);
        _items.add(item);
      } else {
        final item = _LineItem(type: ItemSourceType.custom);
        if (widget.prefillDescription != null)
          item.description = widget.prefillDescription!;
        if (widget.prefillAmount != null)
          item.unitPrice = widget.prefillAmount!;
        item.descController = TextEditingController(text: item.description);
        _items.add(item);
      }
    }
  }

  Future<void> _fetchNextInvoiceNumber() async {
    if (_isInvoiceNoManuallyEdited || widget.invoiceId != null) return;
    setState(() => _isLoadingInvoiceNo = true);
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final nextNo = await repo.getNextInvoiceNumber(_selectedType, _invoiceDate);
      if (mounted && !_isInvoiceNoManuallyEdited && widget.invoiceId == null) {
        setState(() {
          _invoiceNoController.text = nextNo;
          _isLoadingInvoiceNo = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingInvoiceNo = false);
    }
  }

  Future<void> _loadExistingInvoice(int id) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final custRepo = ref.read(customersRepositoryProvider);
    
    final existingInvoice = await repo.getInvoiceById(id);
    final existingItems = await repo.getItemsForInvoice(id);
    final existingCustomer = await custRepo.getCustomerById(existingInvoice.customerId);
    
    if (mounted) {
      setState(() {
        _selectedType = existingInvoice.invoiceType;
        _selectedCustomer = existingInvoice.customerId;
        _invoiceNoController.text = existingInvoice.invoiceNo;
        _isInvoiceNoEditable = existingInvoice.status == InvoiceStatus.draft;
        _isInvoiceNoManuallyEdited = true;
        _invoiceDate = existingInvoice.invoiceDate;
        _dueDate = existingInvoice.dueDate ?? existingInvoice.invoiceDate;
        _paymentTermDays = existingInvoice.paymentTermDays ?? 0;
        _deliveryCharge = existingInvoice.deliveryCharge ?? 0;
        _isDiscountPercentage = existingInvoice.isDiscountPercentage;
        _distributeDiscountAcrossItems = existingInvoice.distributeDiscountAcrossItems;
        _discountAmount = _isDiscountPercentage ? (existingInvoice.discountRate ?? 0) : existingInvoice.discountAmount;
        _notes = existingInvoice.notes ?? '';
        _discountController.text = _discountAmount.toString();
        
          _customerNameController.text = existingCustomer.name;
          _customerAddressController.text = existingCustomer.address ?? '';
          _customerStateController.text = existingCustomer.state ?? '';
          _customerGstinController.text = existingCustomer.gstin ?? '';
          _customerPhoneController.text = existingCustomer.phone ?? '';
          _customerEmailController.text = existingCustomer.email ?? '';
          _customerVendorCodeController.text = existingCustomer.vendorCode ?? '';
        
        _shipToNameController.text = existingInvoice.shipToName ?? '';
        _shipToAddressController.text = existingInvoice.shipToAddress ?? '';
        _placeOfSupplyController.text = existingInvoice.placeOfSupply ?? '';
        _poNumberController.text = existingInvoice.poNumber ?? '';
        _poDate = existingInvoice.poDate;
        _gpNumberController.text = existingInvoice.gpNumber ?? '';
        _gpDate = existingInvoice.gpDate;
        
        _items.clear();
        for (final item in existingItems) {
          final line = _LineItem(type: item.itemSourceType);
          line.linkedId = item.itemSourceType == ItemSourceType.motorJob ? item.motorJobId : item.copperStockId;
          line.description = item.description;
          line.descController = TextEditingController(text: item.description);
          line.hsnCode = item.hsnCode;
          line.qty = item.qty ?? 1.0;
          line.unitPrice = item.unitPrice;
          line.discountPercent = item.discountPercent;
          line.gstRate = item.gstRate;
          _items.add(line);
        }
      });
    }
  }

  void _recalculate() {
    setState(() {}); // Trigger rebuild to update totals
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _customerStateController.dispose();
    _customerGstinController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _customerVendorCodeController.dispose();
    _shipToNameController.dispose();
    _shipToAddressController.dispose();
    _placeOfSupplyController.dispose();
    _poNumberController.dispose();
    _gpNumberController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _addLineItem(ItemSourceType type) {
    setState(() {
      final line = _LineItem(type: type);
      line.descController = TextEditingController();
      _items.add(line);
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;
    if (_customerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a customer/supplier'),
        ),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one line item')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final custRepo = ref.read(customersRepositoryProvider);

      int finalCustomerId = _selectedCustomer ?? 0;

      final customerCompanion = CustomersCompanion(
        name: drift.Value(_customerNameController.text.trim()),
        address: drift.Value(_customerAddressController.text.trim()),
        state: drift.Value(_customerStateController.text.trim()),
        gstin: drift.Value(_customerGstinController.text.trim()),
        phone: drift.Value(_customerPhoneController.text.trim()),
        email: drift.Value(_customerEmailController.text.trim()),
        vendorCode: drift.Value(
          _customerVendorCodeController.text.trim().isNotEmpty
              ? _customerVendorCodeController.text.trim()
              : null,
        ),
      );

      if (_selectedCustomer == null) {
        // New customer
        finalCustomerId = await custRepo.insertCustomer(customerCompanion);
      } else {
        // Update existing customer
        await custRepo.updateCustomer(
          customerCompanion.copyWith(id: drift.Value(_selectedCustomer!)),
        );
      }

      final inputs = _items
          .map(
            (i) => InvoiceLineItemInput(
              lineTotal: i.lineTotal,
              discountPercent: i.discountPercent,
              gstRate: i.gstRate,
            ),
          )
          .toList();
      final totals = TaxCalculator.calculate(
        invoiceType: _selectedType,
        items: inputs,
        bundleDiscountValue: _discountAmount,
        isBundleDiscountPercentage: _isDiscountPercentage,
        distributeBundleDiscount: _distributeDiscountAcrossItems,
        deliveryCharge: _deliveryCharge,
      );

      final duplicate = await repo.findDuplicateInvoice(
        customerId: finalCustomerId,
        type: _selectedType,
        grandTotal: totals.grandTotal,
        date: DateTime.now(),
        excludeInvoiceId: widget.invoiceId,
      );

      if (duplicate != null) {
        bool shouldProceed = false;
        if (mounted) {
          shouldProceed =
              await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Possible Duplicate Invoice'),
                  content: Text(
                    'A similar invoice for ${_customerNameController.text.trim()} totaling ₹${totals.grandTotal.toStringAsFixed(2)} was created on ${duplicate.invoiceDate.toString().split('.')[0]} (Invoice #${duplicate.invoiceNo}). Continue and create anyway, or cancel?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Create Anyway',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;
        }

        if (!shouldProceed) {
          if (mounted) setState(() => _isSaving = false);
          return;
        }
      }

      final isGoods =
          _selectedType == InvoiceType.salesTaxInvoice ||
          _selectedType == InvoiceType.billOfSupply ||
          _selectedType == InvoiceType.deliveryChallan;
      final reqEway = isGoods && totals.grandTotal >= 50000.0;

      // We read settings to see if eInvoice is applicable
      final settings = await ref.read(settingsRepositoryProvider).getSettings();
      final hasGst = _customerGstinController.text.trim().isNotEmpty;
      final isTaxInvoice =
          _selectedType == InvoiceType.serviceTaxInvoice ||
          _selectedType == InvoiceType.salesTaxInvoice;
      final reqEinvoice = settings.eInvoiceApplicable && isTaxInvoice && hasGst;

      final trimmedInvoiceNo = _invoiceNoController.text.trim();
      final isTaken = await repo.isInvoiceNumberTaken(
        trimmedInvoiceNo,
        excludeInvoiceId: widget.invoiceId,
      );
      if (isTaken) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invoice number $trimmedInvoiceNo already exists'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      String? gapNote;
      if (widget.invoiceId == null) {
        gapNote = await repo.checkSequenceGap(
          _selectedType,
          _invoiceDate,
          trimmedInvoiceNo,
        );
      }

      final invoiceCompanion = InvoicesCompanion.insert(
        invoiceNo: trimmedInvoiceNo,
        invoiceType: _selectedType,
        customerId: finalCustomerId,
        invoiceDate: _invoiceDate,
        dueDate: drift.Value(_dueDate),
        paymentTermDays: drift.Value(_paymentTermDays),
        subtotal: totals.subtotal,
        discountAmount: totals.discountAmount,
        isDiscountPercentage: drift.Value(_isDiscountPercentage),
        discountRate: drift.Value(_isDiscountPercentage ? _discountAmount : null),
        distributeDiscountAcrossItems: drift.Value(_distributeDiscountAcrossItems),
        cgstAmount: totals.cgstAmount,
        sgstAmount: totals.sgstAmount,
        igstAmount: drift.Value(totals.igstAmount),
        deliveryCharge: drift.Value(_deliveryCharge),
        grandTotal: totals.grandTotal,
        amountInWords: NumberToWords.convert(totals.grandTotal),
        status: InvoiceStatus.draft,
        notes: drift.Value(_notes.trim()),
        poNumber: drift.Value(
          _poNumberController.text.trim().isEmpty
              ? null
              : _poNumberController.text.trim(),
        ),
        poDate: drift.Value(_poDate),
        gpNumber: drift.Value(_gpNumberController.text),
        gpDate: drift.Value(_gpDate),
        shipToName: drift.Value(
          _shipToNameController.text.trim().isNotEmpty
              ? _shipToNameController.text.trim()
              : null,
        ),
        shipToAddress: drift.Value(
          _shipToAddressController.text.trim().isNotEmpty
              ? _shipToAddressController.text.trim()
              : null,
        ),
        placeOfSupply: drift.Value(
          _placeOfSupplyController.text.trim().isNotEmpty
              ? _placeOfSupplyController.text.trim()
              : null,
        ),

        requiresEWayBill: drift.Value(reqEway),
        requiresEInvoice: drift.Value(reqEinvoice),
      );

      final itemCompanions = _items.map<InvoiceItemsCompanion>((i) {
        return InvoiceItemsCompanion.insert(
          invoiceId: 0, // Placeholder, repo will handle this
          itemSourceType: i.type,
          motorJobId: drift.Value(
            i.type == ItemSourceType.motorJob ? i.linkedId : null,
          ),
          copperStockId: drift.Value(
            i.type == ItemSourceType.copperStock ? i.linkedId : null,
          ),
          description: i.descController?.text ?? i.description,
          hsnCode: drift.Value(
            i.hsnCode != null && i.hsnCode!.trim().isNotEmpty
                ? i.hsnCode!.trim()
                : null,
          ),
          qty: drift.Value(i.qty),
          unitPrice: i.unitPrice,
          discountPercent: drift.Value(i.discountPercent),
          gstRate: drift.Value(i.gstRate),
          lineTotal: i.lineTotal,
        );
      }).toList();

      int savedInvoiceId = 0;
      if (widget.invoiceId != null) {
        await repo.updateInvoiceWithItems(widget.invoiceId!, invoiceCompanion, itemCompanions);
        savedInvoiceId = widget.invoiceId!;
      } else {
        savedInvoiceId = await repo.createInvoiceWithItems(
          invoiceCompanion,
          itemCompanions,
        );
      }

      if (widget.sourceQuotationId != null && widget.invoiceId == null) {
        final quotesRepo = ref.read(quotationsRepositoryProvider);
        await quotesRepo.markConverted(widget.sourceQuotationId!, savedInvoiceId);
      }

      if (mounted) {
        String successMsg = 'Invoice saved successfully!';
        if (gapNote != null) {
          successMsg = 'Invoice saved! Note: $gapNote';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMsg)),
        );
        context.go('/invoices');
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString().replaceFirst('Exception: ', '');
        if (msg.contains('UNIQUE constraint failed: invoices.invoice_no')) {
          msg = 'Invoice number ${_invoiceNoController.text.trim()} already exists';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) if (mounted) setState(() => _hasUnsavedChanges = false);
      setState(() => _isSaving = false);
    }
  }

  Widget _buildLineItemRow(
    int index,
    _LineItem item,
    List<CopperStockData> copperStock,
    List<MotorJob> motorJobs,
  ) {
    final showGst =
        _selectedType != InvoiceType.billOfSupply &&
        _selectedType != InvoiceType.deliveryChallan;

    final rowContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: item.type == ItemSourceType.motorJob
              ? AppSelect<int?>(
                  label: 'Select Motor Job',
                  value: item.linkedId,
                  items: motorJobs
                      .map(
                        (j) => DropdownMenuItem(
                          value: j.id,
                          child: Text(
                            '${j.jobNo} - ${j.motorDescription}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    final job = motorJobs.firstWhere((j) => j.id == val);
                    setState(() {
                      item.linkedId = job.id;
                      String gpStr = "";
                      if (job.gpNumber != null && job.gpNumber!.isNotEmpty) {
                        gpStr += " GP.NO.${job.gpNumber!}";
                      }
                      if (job.gpDate != null) {
                        gpStr +=
                            " GP.DATE.${job.gpDate!.day.toString().padLeft(2, '0')}/${job.gpDate!.month.toString().padLeft(2, '0')}/${job.gpDate!.year}";
                      }
                      String hpStr = job.hp != null ? " ${job.hp} HP" : "";
                      String phaseStr = job.phase != null
                          ? " ${job.phase!.name.toUpperCase()}"
                          : "";
                      item.description =
                          '${job.motorDescription}$hpStr$phaseStr$gpStr\n${job.jobDescription}';
                      item.unitPrice = job.serviceCharge ?? 0;
                      item.hsnCode = job.sacCode;
                      item.qty = 1;
                    });
                    _recalculate();
                  },
                )
              : item.type == ItemSourceType.copperStock
              ? AppSelect<int?>(
                  label: 'Select Copper Stock',
                  value: item.linkedId,
                  items: copperStock
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            c.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    final stock = copperStock.firstWhere((c) => c.id == val);
                    setState(() {
                      item.linkedId = stock.id;
                      item.description = stock.description;
                      item.unitPrice = stock.pricePerKg;
                      item.gstRate = stock.gstRate;
                      item.hsnCode = stock.hsnCode;
                    });
                    _recalculate();
                  },
                )
              : RichTextInput(
                  key: ValueKey('desc_${index}_${item.linkedId}'),
                  label: 'Custom Description',
                  controller: item.descController!,
                  maxLines: 4,
                  onChanged: (val) => item.description = val,
                ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: TextFormField(
            key: ValueKey('hsn_${index}_${item.linkedId}'),
            initialValue: item.hsnCode ?? '',
            decoration: const InputDecoration(labelText: 'SAC/HSN'),
            onChanged: (val) => item.hsnCode = val,
          ),
        ),

        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            key: ValueKey('qty_${index}_${item.linkedId}'),
            initialValue: item.qty.toString(),
            decoration: const InputDecoration(labelText: 'Qty'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() => item.qty = double.tryParse(val) ?? 1);
              _recalculate();
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 150,
          child: TextFormField(
            initialValue: item.unitPrice.toString(),
            key: ValueKey(
              'price_${index}_${item.linkedId}',
            ), // force rebuild if linkedId changes
            decoration: const InputDecoration(labelText: 'Unit Price'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() => item.unitPrice = double.tryParse(val) ?? 0);
              _recalculate();
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: item.discountPercent?.toString() ?? '',
            key: ValueKey('disc_${index}_${item.linkedId}'),
            decoration: const InputDecoration(labelText: 'Disc%'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() => item.discountPercent = double.tryParse(val));
              _recalculate();
            },
          ),
        ),
        const SizedBox(width: 8),
        if (showGst)
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: item.gstRate?.toString() ?? '0',
              key: ValueKey('gst_${index}_${item.linkedId}'),
              decoration: const InputDecoration(labelText: 'GST%'),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() => item.gstRate = double.tryParse(val));
                _recalculate();
              },
            ),
          ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              (() {
                double postItemDiscountBaseline = 0.0;
                for (final i in _items) {
                  postItemDiscountBaseline += i.lineTotal * (1.0 - ((i.discountPercent ?? 0) / 100.0));
                }
                double bundleDiscountAmount = _discountAmount;
                if (_isDiscountPercentage) {
                  bundleDiscountAmount = postItemDiscountBaseline * (_discountAmount / 100.0);
                }
                final distributionFactor = _distributeDiscountAcrossItems && postItemDiscountBaseline > 0
                    ? (postItemDiscountBaseline - bundleDiscountAmount) / postItemDiscountBaseline
                    : 1.0;
                
                final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
                final itemPostDiscount = item.lineTotal - itemDiscount;
                final bundleDiscountShare = itemPostDiscount * (1.0 - distributionFactor);
                final totalDiscount = itemDiscount + bundleDiscountShare;
                
                if (totalDiscount > 0) {
                  final effectivePct = (totalDiscount / item.lineTotal) * 100;
                  return '-₹${totalDiscount.toStringAsFixed(2)} (${effectivePct.toStringAsFixed(1)}%)';
                }
                return '';
              })(),
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              (() {
                double postItemDiscountBaseline = 0.0;
                for (final i in _items) {
                  postItemDiscountBaseline += i.lineTotal * (1.0 - ((i.discountPercent ?? 0) / 100.0));
                }
                double bundleDiscountAmount = _discountAmount;
                if (_isDiscountPercentage) {
                  bundleDiscountAmount = postItemDiscountBaseline * (_discountAmount / 100.0);
                }
                final distributionFactor = _distributeDiscountAcrossItems && postItemDiscountBaseline > 0
                    ? (postItemDiscountBaseline - bundleDiscountAmount) / postItemDiscountBaseline
                    : 1.0;
                
                final itemDiscount = item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
                final itemPostDiscount = item.lineTotal - itemDiscount;
                final finalTaxableValue = itemPostDiscount * distributionFactor;
                final gstAmount = showGst ? (finalTaxableValue * ((item.gstRate ?? 0) / 100)) : 0.0;
                
                return '₹${(finalTaxableValue + gstAmount).toStringAsFixed(2)}';
              })(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ).mono,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _removeLineItem(index);
            _recalculate();
          },
        ),
      ],
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 800),
            child: rowContent,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '₹${value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ).mono,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget _buildLeftPane(
    bool isDesktop,
    bool showGst,
    bool isSupplier,
    AsyncValue<List<CopperStockData>> copperStockAsync,
    AsyncValue<List<MotorJob>> motorJobsAsync,
    AsyncValue<List<Customer>> customersAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isDesktop ? 220 : double.infinity,
              child: TextFormField(
                controller: _invoiceNoController,
                enabled: _isInvoiceNoEditable,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Invoice Number *',
                  helperText: _isInvoiceNoEditable
                      ? 'Max 16 chars (GST Rule 46)'
                      : 'Locked (Finalized/Signed)',
                  prefixIcon: const Icon(Icons.tag),
                  suffixIcon: !_isInvoiceNoEditable
                      ? const Tooltip(
                          message: 'Invoice number is locked for finalized/signed invoices',
                          child: Icon(Icons.lock, size: 18, color: Colors.grey),
                        )
                      : (_isLoadingInvoiceNo
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : (widget.invoiceId == null
                              ? IconButton(
                                  icon: const Icon(Icons.refresh, size: 20),
                                  tooltip: 'Reset to auto-generated sequence',
                                  onPressed: () {
                                    setState(() => _isInvoiceNoManuallyEdited = false);
                                    _fetchNextInvoiceNumber();
                                  },
                                )
                              : null)),
                ),
                onChanged: (val) {
                  if (widget.invoiceId == null) {
                    setState(() => _isInvoiceNoManuallyEdited = true);
                  }
                },
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Invoice number is required';
                  }
                  final trimmed = val.trim();
                  if (trimmed.length > 16) {
                    return 'Max 16 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9\/\-]+$').hasMatch(trimmed)) {
                    return 'Only letters, numbers, - and / allowed';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: isDesktop ? 260 : double.infinity,
              child: AppSelect<InvoiceType>(
                label: 'Invoice Type *',
                value: _selectedType,
                items: const [
                  DropdownMenuItem(
                    value: InvoiceType.serviceTaxInvoice,
                    child: Text('Service Tax Invoice'),
                  ),
                  DropdownMenuItem(
                    value: InvoiceType.salesTaxInvoice,
                    child: Text('Sales Tax Invoice'),
                  ),
                  DropdownMenuItem(
                    value: InvoiceType.billOfSupply,
                    child: Text('Bill of Supply'),
                  ),
                  DropdownMenuItem(
                    value: InvoiceType.purchaseVoucher,
                    child: Text('Purchase Voucher'),
                  ),
                  DropdownMenuItem(
                    value: InvoiceType.deliveryChallan,
                    child: Text('Delivery Challan'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedType = val;
                      // Reset items to avoid incorrect gst application when switching types
                      for (var item in _items) {
                        if (val == InvoiceType.billOfSupply ||
                            val == InvoiceType.deliveryChallan) {
                          item.gstRate = null;
                        }
                      }
                    });
                    _recalculate();
                    if (!_isInvoiceNoManuallyEdited && widget.invoiceId == null) {
                      _fetchNextInvoiceNumber();
                    }
                  }
                },
              ),
            ),
            SizedBox(
              width: isDesktop ? 300 : double.infinity,
              child: customersAsync.when(
                data: (customers) {
                  return Autocomplete<Customer>(
                    initialValue: TextEditingValue(
                      text: _customerNameController.text,
                    ),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      final query = textEditingValue.text.toLowerCase().trim();
                      if (query.isEmpty) {
                        return const Iterable<Customer>.empty();
                      }
                      return customers.where((Customer customer) {
                        // case-insensitive, whitespace-forgiving
                        final nameMatches = customer.name
                            .toLowerCase()
                            .replaceAll(RegExp(r'\s+'), ' ')
                            .contains(query.replaceAll(RegExp(r'\s+'), ' '));
                        return nameMatches;
                      });
                    },
                    displayStringForOption: (Customer option) => option.name,
                    onSelected: (Customer selection) {
                      setState(() {
                        _selectedCustomer = selection.id;
                        _customerNameController.text = selection.name;
                        _customerAddressController.text = selection.address;
                        _customerStateController.text = selection.state;
                        _customerGstinController.text = selection.gstin ?? '';
                        _customerPhoneController.text = selection.phone;
                        _customerEmailController.text = selection.email;
                        _customerVendorCodeController.text =
                            selection.vendorCode ?? '';
                        _placeOfSupplyController.text = selection
                            .state; // Auto-derive place of supply from state
                      });
                      _recalculate();
                    },
                    fieldViewBuilder:
                        (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            onChanged: (val) {
                              _customerNameController.text = val;
                              if (_selectedCustomer != null) {
                                final selectedCustObj = customers.firstWhere(
                                  (c) => c.id == _selectedCustomer,
                                  orElse: () => customers.first,
                                );
                                if (selectedCustObj.name != val) {
                                  setState(() => _selectedCustomer = null);
                                }
                              }
                            },
                            decoration: InputDecoration(
                              labelText: isSupplier
                                  ? 'Supplier Name *'
                                  : 'Customer Name *',
                              suffixIcon:
                                  _selectedCustomer == null &&
                                      fieldTextEditingController.text.isNotEmpty
                                  ? Tooltip(
                                      message:
                                          'Will be added as a new customer',
                                      child: Icon(
                                        Icons.person_add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  : null,
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? 'Required'
                                : null,
                          );
                        },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => const Text('Error loading customers'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isDesktop ? 400 : double.infinity,
              child: TextFormField(
                controller: _customerAddressController,
                decoration: const InputDecoration(labelText: 'Address *'),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: TextFormField(
                controller: _customerStateController,
                decoration: const InputDecoration(labelText: 'State *'),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: GstinInputField(
                controller: _customerGstinController,
                label: 'GSTIN (Optional)',
              ),
            ),
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: TextFormField(
                controller: _customerPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone (Optional)',
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: TextFormField(
                controller: _customerEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: TextFormField(
                controller: _customerVendorCodeController,
                decoration: const InputDecoration(
                  labelText: 'Vendor Code (Optional)',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Shipping & Supply Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isDesktop ? 300 : double.infinity,
              child: TextFormField(
                controller: _shipToNameController,
                decoration: const InputDecoration(
                  labelText: 'Ship To Name (Optional)',
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 300 : double.infinity,
              child: TextFormField(
                controller: _shipToAddressController,
                decoration: const InputDecoration(
                  labelText: 'Ship To Address (Optional)',
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 200 : double.infinity,
              child: TextFormField(
                controller: _placeOfSupplyController,
                decoration: const InputDecoration(
                  labelText: 'Place of Supply (Optional)',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const SizedBox(height: 24),
        const Text(
          'Invoice Dates & Terms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _invoiceDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _invoiceDate = picked;
                      if (_paymentTermDays != null) {
                        _dueDate = _invoiceDate.add(
                          Duration(days: _paymentTermDays!),
                        );
                      }
                    });
                    if (!_isInvoiceNoManuallyEdited && widget.invoiceId == null) {
                      _fetchNextInvoiceNumber();
                    }
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Invoice Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    "${_invoiceDate.day}/${_invoiceDate.month}/${_invoiceDate.year}",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (_selectedType == InvoiceType.serviceTaxInvoice ||
                _selectedType == InvoiceType.salesTaxInvoice ||
                _selectedType == InvoiceType.billOfSupply) ...[
              Expanded(
                child: AppSelect<int?>(
                  label: 'Payment Term',
                  value: _paymentTermDays,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('None')),
                    DropdownMenuItem(value: 5, child: Text('5 days')),
                    DropdownMenuItem(value: 15, child: Text('15 days')),
                    DropdownMenuItem(value: 30, child: Text('30 days')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _paymentTermDays = val;
                      if (val != null) {
                        _dueDate = _invoiceDate.add(Duration(days: val));
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? _invoiceDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dueDate != null
                        ? "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"
                        : 'Select Due Date',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Purchase Order Details (Optional)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'PO Number',
                controller: _poNumberController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _poDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _poDate = picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'PO Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _poDate != null
                        ? "${_poDate!.day}/${_poDate!.month}/${_poDate!.year}"
                        : 'Select Date',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'GP Number',
                controller: _gpNumberController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _gpDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _gpDate = picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'GP Date',
                  ),
                  child: Text(
                    _gpDate != null
                        ? "${_gpDate!.day}/${_gpDate!.month}/${_gpDate!.year}"
                        : 'Select Date',
                  ),
                ),
              ),
            ),
          ],
        ),
        const Text(
          'Line Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        copperStockAsync.when(
          data: (copperStock) => motorJobsAsync.when(
            data: (motorJobs) => Column(
              children: _items.asMap().entries.map((entry) {
                return _buildLineItemRow(
                  entry.key,
                  entry.value,
                  copperStock,
                  motorJobs,
                );
              }).toList(),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => const Text('Error loading jobs'),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, s) => const Text('Error loading stock'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_selectedType == InvoiceType.serviceTaxInvoice) ...[
              TextButton.icon(
                onPressed: () => _addLineItem(ItemSourceType.motorJob),
                icon: const Icon(Icons.engineering),
                label: const Text('Add Motor Job'),
              ),
            ],
            if (_selectedType != InvoiceType.serviceTaxInvoice) ...[
              TextButton.icon(
                onPressed: () => _addLineItem(ItemSourceType.copperStock),
                icon: const Icon(Icons.inventory_2),
                label: const Text('Add Copper Stock'),
              ),
            ],
            TextButton.icon(
              onPressed: () => _addLineItem(ItemSourceType.custom),
              icon: const Icon(Icons.edit),
              label: const Text('Add Custom Item'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: _notes,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          onChanged: (val) {
            _notes = val;
          },
        ),
      ],
    );
  }

  Widget _buildRightPane(bool showGst, TaxCalculationResult totals) {
    final isGoods =
        _selectedType == InvoiceType.salesTaxInvoice ||
        _selectedType == InvoiceType.billOfSupply ||
        _selectedType == InvoiceType.deliveryChallan;
    final reqEway = isGoods && totals.grandTotal >= 50000.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reqEway)
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(8.0),
                color: Colors.amber.shade100,
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.amber.shade900, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This invoice may require an e-Way Bill (goods value ≥ ₹50,000).',
                        style: TextStyle(color: Colors.amber.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildSummaryRow('Subtotal:', totals.subtotal),

            // Discount Toggle
            const SizedBox(height: 8),
            const Text('Discount'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(
                        () => _discountAmount = double.tryParse(val) ?? 0,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ToggleButtons(
                  isSelected: [
                    _isDiscountPercentage == false,
                    _isDiscountPercentage == true,
                  ],
                  onPressed: (index) {
                    setState(() => _isDiscountPercentage = index == 1);
                  },
                  children: const [Text('₹'), Text('%')],
                ),
              ],
            ),
            if (totals.bundleDiscountAmount > 0) ...[
              const SizedBox(height: 8),
              const Text('Bundle Discount Mode:', style: TextStyle(fontSize: 12)),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          label: Text('Distribute (Affects GST)', style: TextStyle(fontSize: 12)),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text('Overall Only', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      selected: {_distributeDiscountAcrossItems},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _distributeDiscountAcrossItems = newSelection.first;
                        });
                        _recalculate();
                      },
                    ),
                  ),
                ],
              ),
            ],
            if (totals.discountAmount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildSummaryRow(
                  'Total Discount applied:',
                  -totals.discountAmount,
                ),
              ),

            if (_selectedType == InvoiceType.deliveryChallan ||
                _selectedType == InvoiceType.serviceTaxInvoice) ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Delivery Charge'),
                initialValue: _deliveryCharge.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() => _deliveryCharge = double.tryParse(val) ?? 0);
                },
              ),
            ],

            if (showGst &&
                (totals.cgstAmount > 0 ||
                    totals.sgstAmount > 0 ||
                    totals.igstAmount > 0)) ...[
              const Divider(),
              _buildSummaryRow('IGST:', totals.igstAmount),
              _buildSummaryRow('CGST:', totals.cgstAmount),
              _buildSummaryRow('SGST:', totals.sgstAmount),
            ],
            const Divider(thickness: 2),
            _buildSummaryRow('Grand Total:', totals.grandTotal, isBold: true),
            const SizedBox(height: 8),
            Text(
              NumberToWords.convert(totals.grandTotal),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersStreamProvider);
    final copperStockAsync = ref.watch(copperStockStreamProvider);
    final motorJobsAsync = ref.watch(motorJobsStreamProvider);

    final showGst =
        _selectedType != InvoiceType.billOfSupply &&
        _selectedType != InvoiceType.deliveryChallan;
    final isSupplier = _selectedType == InvoiceType.purchaseVoucher;

    // Calculate totals for preview
    final inputs = _items
        .map(
          (i) =>
              InvoiceLineItemInput(lineTotal: i.lineTotal, discountPercent: i.discountPercent, gstRate: i.gstRate),
        )
        .toList();
    final totals = TaxCalculator.calculate(
      invoiceType: _selectedType,
      items: inputs,
      bundleDiscountValue: _discountAmount,
      isBundleDiscountPercentage: _isDiscountPercentage,
      distributeBundleDiscount: _distributeDiscountAcrossItems,
      deliveryCharge: _deliveryCharge,
    );

    final isDesktop = MediaQuery.of(context).size.width > 900;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Discard',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (shouldPop ?? false) {
          if (context.mounted) context.pop();
        }
      },
      child: AppLayout(
        currentRoute: '/invoices',
        appBar: AppBar(title: const Text('Invoice Form')),
        child: Form(
          key: _formKey,
          onChanged: () {
            if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.go('/invoices'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.invoiceId != null ? 'Edit Invoice' : 'New Invoice',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    AppButton(
                      label: 'Save & Generate',
                      onPressed: _saveInvoice,
                      isLoading: _isSaving,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: _buildLeftPane(
                                  isDesktop,
                                  showGst,
                                  isSupplier,
                                  copperStockAsync,
                                  motorJobsAsync,
                                  customersAsync,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: _buildRightPane(showGst, totals),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLeftPane(
                                isDesktop,
                                showGst,
                                isSupplier,
                                copperStockAsync,
                                motorJobsAsync,
                                customersAsync,
                              ),
                              const SizedBox(height: 24),
                              _buildRightPane(showGst, totals),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
