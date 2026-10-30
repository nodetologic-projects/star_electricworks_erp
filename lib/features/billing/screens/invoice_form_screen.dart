import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:starelectricerp/data/repositories/motor_jobs_repository.dart';
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
import 'package:starelectricerp/core/widgets/app_date_field.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/financial_year.dart';

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
  final int? prefillOriginalInvoiceId;

  const InvoiceFormScreen({
    super.key,
    this.invoiceId,
    this.prefillJobId,
    this.prefillType,
    this.prefillCustomerId,
    this.sourceQuotationId,
    this.prefillDescription,
    this.prefillAmount,
    this.prefillOriginalInvoiceId,
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
  bool _isDueDateManuallyOverridden = false;
  int? _paymentTermDays;
  final List<_LineItem> _items = [];
  String _notes = '';

  double _deliveryCharge = 0;
  TaxMode _taxMode = TaxMode.cgst_sgst;

  int? _selectedOriginalInvoiceId;
  Invoice? _originalInvoice;
  NoteReason? _selectedNoteReason;
  final TextEditingController _noteReasonTextController = TextEditingController();
  bool _returnStockToInventory = false;
  double _remainingCreditableAmount = 0.0;
  List<Invoice> _customerInvoices = [];

  static const Map<String, String> _gstStateCodes = {
    '01': 'Jammu & Kashmir',
    '02': 'Himachal Pradesh',
    '03': 'Punjab',
    '04': 'Chandigarh',
    '05': 'Uttarakhand',
    '06': 'Haryana',
    '07': 'Delhi',
    '08': 'Rajasthan',
    '09': 'Uttar Pradesh',
    '10': 'Bihar',
    '11': 'Sikkim',
    '12': 'Arunachal Pradesh',
    '13': 'Nagaland',
    '14': 'Manipur',
    '15': 'Mizoram',
    '16': 'Tripura',
    '17': 'Meghalaya',
    '18': 'Assam',
    '19': 'West Bengal',
    '20': 'Jharkhand',
    '21': 'Odisha',
    '22': 'Chhattisgarh',
    '23': 'Madhya Pradesh',
    '24': 'Gujarat',
    '25': 'Daman & Diu',
    '26': 'Dadra & Nagar Haveli',
    '27': 'Maharashtra',
    '28': 'Andhra Pradesh',
    '29': 'Karnataka',
    '30': 'Goa',
    '31': 'Lakshadweep',
    '32': 'Kerala',
    '33': 'Tamil Nadu',
    '34': 'Puducherry',
    '35': 'Andaman & Nicobar Islands',
    '36': 'Telangana',
    '37': 'Andhra Pradesh (New)',
    '38': 'Ladakh',
  };

  String _getCompanyState(CompanySetting? company) {
    if (company != null && company.gstin.length >= 2) {
      final code = company.gstin.substring(0, 2);
      final mapped = _gstStateCodes[code];
      if (mapped != null) return mapped;
    }
    return 'Gujarat';
  }

  bool _isCustomerInDifferentState(String customerState, String companyState) {
    final cust = customerState.trim().toLowerCase();
    if (cust.isEmpty) return false;
    final comp = companyState.trim().toLowerCase();
    if (cust == comp) return false;

    final custFromCode = _gstStateCodes[customerState.trim()]?.toLowerCase();
    if (custFromCode != null && custFromCode == comp) return false;

    if (comp == 'gujarat') {
      if (cust == 'gj' || cust == '24' || cust == 'guj' || cust == 'gujarat') {
        return false;
      }
    }

    return true;
  }

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _invoiceDate = IstDateUtils.nowIst();
    _selectedType = widget.prefillType ?? InvoiceType.serviceTaxInvoice;
    _selectedCustomer = widget.prefillCustomerId;

    if (widget.prefillType == InvoiceType.credit_note) {
      _selectedNoteReason = NoteReason.sales_return;
    } else if (widget.prefillType == InvoiceType.debit_note) {
      _selectedNoteReason = NoteReason.additional_charges;
    }

    if (widget.invoiceId != null) {
      _isInvoiceNoManuallyEdited = false;
      Future.microtask(() => _loadExistingInvoice(widget.invoiceId!));
    } else {
      _fetchNextInvoiceNumber();
      if (widget.prefillOriginalInvoiceId != null) {
        Future.microtask(() => _loadPrefillOriginalInvoice(widget.prefillOriginalInvoiceId!));
      } else if (widget.prefillCustomerId != null) {
        _loadPrefillCustomer(widget.prefillCustomerId!);
        Future.microtask(() => _loadCustomerInvoices(widget.prefillCustomerId!));
      }
      if (widget.prefillJobId != null) {
        // We prepopulate later when async data loads, for now just add a row
        final item = _LineItem(type: ItemSourceType.motorJob)
            ..linkedId = widget.prefillJobId;
        item.descController = TextEditingController(text: item.description);
        _items.add(item);
        _loadPrefillJob(widget.prefillJobId!);
      } else if (widget.prefillOriginalInvoiceId == null || widget.prefillType != InvoiceType.credit_note) {
        final item = _LineItem(type: ItemSourceType.custom);
        if (widget.prefillDescription != null) {
          item.description = widget.prefillDescription!;
        }
        if (widget.prefillAmount != null) {
          item.unitPrice = widget.prefillAmount!;
        }
        item.descController = TextEditingController(text: item.description);
        _items.add(item);
      }
    }
  }

  Future<void> _loadPrefillJob(int jobId) async {
    try {
      final repo = ref.read(motorJobsRepositoryProvider);
      final job = await repo.getMotorJobById(jobId);
      final settings = await ref.read(settingsRepositoryProvider).getSettings();
      if (mounted) {
        setState(() {
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

          final item = _items.firstWhere(
            (it) => it.linkedId == jobId,
            orElse: () => _items.first,
          );
          item.description =
              '${job.motorDescription}$hpStr$phaseStr$gpStr\n${job.jobDescription}';
          item.descController?.text = item.description;
          item.unitPrice = job.serviceCharge ?? 0;
          if (_selectedType == InvoiceType.deliveryChallan) {
            final defaultHsn = settings.defaultMotorHsn;
            item.hsnCode = (job.hsnCode != null && job.hsnCode!.trim().isNotEmpty)
                ? job.hsnCode!.trim()
                : (defaultHsn != null && defaultHsn.trim().isNotEmpty ? defaultHsn.trim() : null);
          } else {
            item.hsnCode = job.sacCode;
          }
          item.qty = 1;
        });
        _recalculate();
      }
    } catch (e) {
      debugPrint('Error loading prefill job: $e');
    }
  }

  Future<void> _loadPrefillCustomer(int customerId) async {
    try {
      final custRepo = ref.read(customersRepositoryProvider);
      final customer = await custRepo.getCustomerById(customerId);
      if (mounted) {
        setState(() {
          _selectedCustomer = customer.id;
          _customerNameController.text = customer.name;
          _customerAddressController.text = customer.address;
          _customerStateController.text = customer.state;
          _customerGstinController.text = customer.gstin ?? '';
          _customerPhoneController.text = customer.phone;
          _customerEmailController.text = customer.email;
          _customerVendorCodeController.text = customer.vendorCode ?? '';
          _placeOfSupplyController.text = customer.state.isNotEmpty ? customer.state : 'Gujarat';
        });
      }
    } catch (e) {
      debugPrint('Error loading prefill customer: $e');
    }
  }

  Future<void> _fetchNextInvoiceNumber() async {
    if (_isInvoiceNoManuallyEdited || !_isInvoiceNoEditable) return;
    setState(() => _isLoadingInvoiceNo = true);
    try {
      final repo = ref.read(invoicesRepositoryProvider);
      final nextNo = await repo.getNextInvoiceNumber(_selectedType, _invoiceDate);
      if (mounted && !_isInvoiceNoManuallyEdited && _isInvoiceNoEditable) {
        setState(() {
          _invoiceNoController.text = nextNo;
          _isLoadingInvoiceNo = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingInvoiceNo = false);
    }
  }

  Future<void> _loadCustomerInvoices(int customerId, {int? preselectInvoiceId}) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final allInvoices = await repo.getAllInvoices();
    final custInvoices = allInvoices.where((inv) =>
      inv.customerId == customerId &&
      inv.status != InvoiceStatus.draft &&
      (inv.invoiceType == InvoiceType.serviceTaxInvoice ||
       inv.invoiceType == InvoiceType.salesTaxInvoice ||
       inv.invoiceType == InvoiceType.billOfSupply)
    ).toList();

    if (mounted) {
      setState(() {
        _customerInvoices = custInvoices;
      });
      if (preselectInvoiceId != null) {
        final match = custInvoices.where((i) => i.id == preselectInvoiceId).firstOrNull;
        if (match != null) {
          await _onOriginalInvoiceSelected(match, prefillLines: _selectedType == InvoiceType.credit_note);
        }
      }
    }
  }

  Future<void> _onOriginalInvoiceSelected(Invoice orig, {bool prefillLines = false}) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final remaining = await repo.getRemainingCreditableAmount(orig.id, excludeNoteId: widget.invoiceId);
    
    List<_LineItem>? newLines;
    if (prefillLines) {
      final origItems = await repo.getItemsForInvoice(orig.id);
      newLines = origItems.map((item) {
        final line = _LineItem(type: item.itemSourceType);
        line.linkedId = item.itemSourceType == ItemSourceType.motorJob ? item.motorJobId : item.copperStockId;
        line.description = item.description;
        line.descController = TextEditingController(text: item.description);
        line.hsnCode = item.hsnCode;
        line.qty = item.qty ?? 1.0;
        line.unitPrice = item.unitPrice;
        line.discountPercent = item.discountPercent;
        line.gstRate = orig.invoiceType == InvoiceType.billOfSupply ? null : item.gstRate;
        return line;
      }).toList();
    }

    if (mounted) {
      setState(() {
        _selectedOriginalInvoiceId = orig.id;
        _originalInvoice = orig;
        _remainingCreditableAmount = remaining;
        _taxMode = orig.taxMode == TaxMode.all_three ? TaxMode.cgst_sgst : orig.taxMode;
        if (newLines != null && newLines.isNotEmpty) {
          _items.clear();
          _items.addAll(newLines);
        }
        if (_selectedCustomer == null) {
          _selectedCustomer = orig.customerId;
          _loadPrefillCustomer(orig.customerId);
        }
      });
      _recalculate();
    }
  }

  Future<void> _loadPrefillOriginalInvoice(int origId) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final orig = await repo.getInvoiceById(origId);
    await _loadCustomerInvoices(orig.customerId, preselectInvoiceId: orig.id);
    await _onOriginalInvoiceSelected(orig, prefillLines: _selectedType == InvoiceType.credit_note);
  }

  Future<void> _loadExistingInvoice(int id) async {
    final repo = ref.read(invoicesRepositoryProvider);
    final custRepo = ref.read(customersRepositoryProvider);
    
    final existingInvoice = await repo.getInvoiceById(id);
    final existingItems = await repo.getItemsForInvoice(id);
    final existingCustomer = await custRepo.getCustomerById(existingInvoice.customerId);

    Invoice? orig;
    double remaining = 0.0;
    bool hasStockReturn = false;
    if (existingInvoice.originalInvoiceId != null) {
      orig = await repo.getInvoiceById(existingInvoice.originalInvoiceId!);
      remaining = await repo.getRemainingCreditableAmount(existingInvoice.originalInvoiceId!, excludeNoteId: id);
      final db = ref.read(databaseProvider);
      final movements = await (db.select(db.stockMovements)..where((t) => t.referenceInvoiceId.equals(id))).get();
      hasStockReturn = movements.any((m) => m.movementType == MovementType.sales_return_in);
      await _loadCustomerInvoices(existingInvoice.customerId);
    }
    
    if (mounted) {
      setState(() {
        _selectedType = existingInvoice.invoiceType;
        _selectedCustomer = existingInvoice.customerId;
        _selectedOriginalInvoiceId = existingInvoice.originalInvoiceId;
        _selectedNoteReason = existingInvoice.noteReason;
        _noteReasonTextController.text = existingInvoice.noteReasonText ?? '';
        _originalInvoice = orig;
        _remainingCreditableAmount = remaining;
        _returnStockToInventory = hasStockReturn;
        _invoiceNoController.text = existingInvoice.invoiceNo;
        _isInvoiceNoEditable = existingInvoice.status == InvoiceStatus.draft;
        _isInvoiceNoManuallyEdited = false;
        _invoiceDate = existingInvoice.invoiceDate;
        _dueDate = existingInvoice.dueDate ?? existingInvoice.invoiceDate;
        _paymentTermDays = existingInvoice.paymentTermDays;
        final expectedDue = _paymentTermDays != null && _paymentTermDays! > 0
            ? _invoiceDate.add(Duration(days: _paymentTermDays!))
            : null;
        _isDueDateManuallyOverridden = expectedDue == null || !IstDateUtils.isSameDay(_dueDate!, expectedDue);
        _deliveryCharge = existingInvoice.deliveryCharge ?? 0;
        _taxMode = existingInvoice.taxMode == TaxMode.all_three
            ? TaxMode.cgst_sgst
            : existingInvoice.taxMode;
        _notes = existingInvoice.notes ?? '';
        
          _customerNameController.text = existingCustomer.name;
          _customerAddressController.text = existingCustomer.address;
          _customerStateController.text = existingCustomer.state;
          _customerGstinController.text = existingCustomer.gstin ?? '';
          _customerPhoneController.text = existingCustomer.phone;
          _customerEmailController.text = existingCustomer.email;
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
    _noteReasonTextController.dispose();
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

    if (_selectedType.isNote && _selectedOriginalInvoiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an original invoice for the ${_selectedType == InvoiceType.credit_note ? 'Credit Note' : 'Debit Note'}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedType.isNote && _originalInvoice != null) {
      final origDate = IstDateUtils.toMidnightIst(_originalInvoice!.invoiceDate);
      final noteDate = IstDateUtils.toMidnightIst(_invoiceDate);
      if (noteDate.isBefore(origDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Note date cannot be before original invoice date (${DateFormat('dd/MM/yyyy').format(_originalInvoice!.invoiceDate)})',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
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
        taxMode: _taxMode,
        deliveryCharge: _deliveryCharge,
        isOriginalBillOfSupply:
            _selectedType.isNote &&
            _originalInvoice?.invoiceType == InvoiceType.billOfSupply,
      );

      if (_selectedType == InvoiceType.credit_note) {
        if (totals.grandTotal > _remainingCreditableAmount + 0.001) {
          if (mounted) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Credit note total (₹${totals.grandTotal.toStringAsFixed(2)}) cannot exceed remaining creditable amount (₹${_remainingCreditableAmount.toStringAsFixed(2)})',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        if (_originalInvoice != null) {
          final origDate = _originalInvoice!.invoiceDate;
          final fyEndYear = origDate.month >= 4 ? origDate.year + 1 : origDate.year;
          final gstDeadline = DateTime(fyEndYear, 11, 30, 23, 59, 59);
          if (_invoiceDate.isAfter(gstDeadline)) {
            bool proceed = false;
            if (mounted) {
              proceed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('GST Time Limit Warning'),
                  content: Text(
                    'This may be past the GST time limit for a credit note against this invoice — confirm with your CA.\n\n(30 November $fyEndYear has passed).\n\nDo you want to proceed and save anyway?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Proceed Anyway'),
                    ),
                  ],
                ),
              ) ?? false;
            }
            if (!proceed) {
              if (mounted) setState(() => _isSaving = false);
              return;
            }
          }
        }
      }

      if (_selectedType.isNote && _selectedOriginalInvoiceId != null) {
        final duplicateNote = await repo.findDuplicateNote(
          originalInvoiceId: _selectedOriginalInvoiceId!,
          type: _selectedType,
          grandTotal: totals.grandTotal,
          date: _invoiceDate,
          excludeInvoiceId: widget.invoiceId,
        );
        if (duplicateNote != null) {
          bool shouldProceed = false;
          if (mounted) {
            shouldProceed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Possible Duplicate ${_selectedType == InvoiceType.credit_note ? 'Credit' : 'Debit'} Note'),
                content: Text(
                  'A similar ${_selectedType == InvoiceType.credit_note ? 'Credit Note' : 'Debit Note'} against invoice ${_originalInvoice?.invoiceNo ?? ''} totaling ₹${totals.grandTotal.toStringAsFixed(2)} was created within the last 24 hours (Note #${duplicateNote.invoiceNo}). Continue and create anyway, or cancel?',
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
            ) ?? false;
          }
          if (!shouldProceed) {
            if (mounted) setState(() => _isSaving = false);
            return;
          }
        }
      } else {
        final duplicate = await repo.findDuplicateInvoice(
          customerId: finalCustomerId,
          type: _selectedType,
          grandTotal: totals.grandTotal,
          date: _invoiceDate,
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
      }

      if (_selectedType == InvoiceType.deliveryChallan) {
        final missingHsnCount = _items.where((i) => i.hsnCode == null || i.hsnCode!.trim().isEmpty).length;
        if (missingHsnCount > 0) {
          bool shouldProceed = false;
          if (mounted) {
            shouldProceed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Missing HSN Code'),
                content: Text(
                  'HSN code is missing on $missingHsnCount line(s). A delivery challan normally needs it — save anyway?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Save Anyway'),
                  ),
                ],
              ),
            ) ?? false;
          }

          if (!shouldProceed) {
            if (mounted) setState(() => _isSaving = false);
            return;
          }
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
        isDiscountPercentage: const drift.Value(false),
        discountRate: const drift.Value(null),
        distributeDiscountAcrossItems: const drift.Value(false),
        cgstAmount: totals.cgstAmount,
        sgstAmount: totals.sgstAmount,
        igstAmount: drift.Value(totals.igstAmount),
        taxMode: drift.Value(_taxMode),
        useIgst: drift.Value(_taxMode == TaxMode.igst_only),
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

        requiresEWayBill: drift.Value(!_selectedType.isCreditNote && reqEway),
        requiresEInvoice: drift.Value(reqEinvoice),
        originalInvoiceId: drift.Value(_selectedOriginalInvoiceId),
        noteReason: drift.Value(_selectedNoteReason),
        noteReasonText: drift.Value(
          _noteReasonTextController.text.trim().isNotEmpty
              ? _noteReasonTextController.text.trim()
              : null,
        ),
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
        await repo.updateInvoiceWithItems(
          widget.invoiceId!,
          invoiceCompanion,
          itemCompanions,
          returnStockToInventory: _returnStockToInventory,
        );
        savedInvoiceId = widget.invoiceId!;
      } else {
        savedInvoiceId = await repo.createInvoiceWithItems(
          invoiceCompanion,
          itemCompanions,
          returnStockToInventory: _returnStockToInventory,
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
    List<MotorJob> motorJobs, {
    String? defaultMotorHsn,
  }) {
    final showGst =
        _selectedType != InvoiceType.billOfSupply &&
        _selectedType != InvoiceType.deliveryChallan &&
        !(_selectedType.isNote && _originalInvoice?.invoiceType == InvoiceType.billOfSupply);

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
                      item.descController?.text = item.description;
                      item.unitPrice = job.serviceCharge ?? 0;
                      if (_selectedType == InvoiceType.deliveryChallan) {
                        item.hsnCode = (job.hsnCode != null && job.hsnCode!.trim().isNotEmpty)
                            ? job.hsnCode!.trim()
                            : (defaultMotorHsn != null && defaultMotorHsn.trim().isNotEmpty ? defaultMotorHsn.trim() : null);
                      } else {
                        item.hsnCode = job.sacCode;
                      }
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
            key: ValueKey('hsn_${index}_${item.linkedId}_${item.hsnCode}'),
            initialValue: item.hsnCode ?? '',
            decoration: InputDecoration(
              labelText: _selectedType == InvoiceType.deliveryChallan ? 'HSN' : 'SAC/HSN',
            ),
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
                final itemDiscount =
                    item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
                if (itemDiscount > 0) {
                  return '-₹${itemDiscount.toStringAsFixed(2)} (${item.discountPercent}%)';
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
                final itemDiscount =
                    item.lineTotal * ((item.discountPercent ?? 0.0) / 100.0);
                final taxable = item.lineTotal - itemDiscount;
                final gst =
                    showGst ? (taxable * ((item.gstRate ?? 0) / 100)) : 0.0;
                return '₹${(taxable + gst).toStringAsFixed(2)}';
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
    String companyState, {
    String? defaultMotorHsn,
  }) {
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
                  DropdownMenuItem(
                    value: InvoiceType.credit_note,
                    child: Text('Credit Note'),
                  ),
                  DropdownMenuItem(
                    value: InvoiceType.debit_note,
                    child: Text('Debit Note'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedType = val;
                      if (val == InvoiceType.credit_note && _selectedNoteReason == null) {
                        _selectedNoteReason = NoteReason.sales_return;
                      } else if (val == InvoiceType.debit_note && _selectedNoteReason == null) {
                        _selectedNoteReason = NoteReason.additional_charges;
                      }
                      // Reset items to avoid incorrect gst application when switching types
                      for (var item in _items) {
                        if (val == InvoiceType.billOfSupply ||
                            val == InvoiceType.deliveryChallan ||
                            (val.isNote && _originalInvoice?.invoiceType == InvoiceType.billOfSupply)) {
                          item.gstRate = null;
                        }
                      }
                    });
                    if (val.isNote && _selectedCustomer != null) {
                      _loadCustomerInvoices(_selectedCustomer!);
                    }
                    _recalculate();
                    if (!_isInvoiceNoManuallyEdited && widget.invoiceId == null) {
                      _fetchNextInvoiceNumber();
                    }
                  }
                },
              ),
            ),
            if (showGst)
              SizedBox(
                width: isDesktop ? 240 : double.infinity,
                child: AppSelect<TaxMode>(
                  label: 'Tax Type',
                  value: _taxMode == TaxMode.all_three ? TaxMode.cgst_sgst : _taxMode,
                  helperText: _selectedType.isNote
                      ? 'Inherited from original (${_taxMode == TaxMode.igst_only ? 'IGST' : 'CGST+SGST'})'
                      : null,
                  items: [
                    DropdownMenuItem(
                      value: TaxMode.cgst_sgst,
                      child: Text(TaxMode.cgst_sgst.getLabel(
                        _items
                            .map((i) => i.gstRate)
                            .where((r) => r != null && r > 0)
                            .map((r) => r!)
                            .toSet()
                            .length == 1
                            ? _items
                                .map((i) => i.gstRate)
                                .where((r) => r != null && r > 0)
                                .map((r) => r!)
                                .toSet()
                                .first
                            : null,
                      )),
                    ),
                    DropdownMenuItem(
                      value: TaxMode.igst_only,
                      child: Text(TaxMode.igst_only.getLabel(
                        _items
                            .map((i) => i.gstRate)
                            .where((r) => r != null && r > 0)
                            .map((r) => r!)
                            .toSet()
                            .length == 1
                            ? _items
                                .map((i) => i.gstRate)
                                .where((r) => r != null && r > 0)
                                .map((r) => r!)
                                .toSet()
                                .first
                            : null,
                      )),
                    ),
                  ],
                  onChanged: (_isInvoiceNoEditable && !_selectedType.isNote)
                      ? (val) {
                          if (val != null) {
                            setState(() => _taxMode = val);
                            _recalculate();
                          }
                        }
                      : null,
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
                      if (_selectedType.isNote) {
                        _loadCustomerInvoices(selection.id);
                      }
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
                onChanged: (_) => setState(() {}),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        if (showGst &&
            _taxMode != TaxMode.igst_only &&
            _isCustomerInDifferentState(_customerStateController.text, companyState)) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade900, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Customer is in another state — IGST usually applies. Suggest IGST?',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                if (_isInvoiceNoEditable)
                  TextButton(
                    onPressed: () {
                      setState(() => _taxMode = TaxMode.igst_only);
                      _recalculate();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.amber.shade900,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Switch to IGST',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
        if (_selectedType.isNote) ...[
          const SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            color: _selectedType == InvoiceType.credit_note
                ? Colors.teal.shade50.withValues(alpha: 0.4)
                : Colors.orange.shade50.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: _selectedType == InvoiceType.credit_note
                    ? Colors.teal.shade200
                    : Colors.orange.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _selectedType == InvoiceType.credit_note
                            ? Icons.assignment_return
                            : Icons.note_add,
                        color: _selectedType == InvoiceType.credit_note
                            ? Colors.teal.shade800
                            : Colors.deepOrange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedType == InvoiceType.credit_note
                            ? 'Credit Note Details'
                            : 'Debit Note Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedType == InvoiceType.credit_note
                              ? Colors.teal.shade900
                              : Colors.deepOrange.shade900,
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
                        width: isDesktop ? 340 : double.infinity,
                        child: AppSelect<int?>(
                          label: 'Original Invoice *',
                          value: _selectedOriginalInvoiceId,
                          helperText: _customerInvoices.isEmpty
                              ? (_selectedCustomer == null
                                  ? 'Select a customer above first'
                                  : 'No finalized invoices found for this customer')
                              : 'Must link to a finalized invoice',
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('-- Select Original Invoice --'),
                            ),
                            ..._customerInvoices.map(
                              (inv) => DropdownMenuItem(
                                value: inv.id,
                                child: Text(
                                  '${inv.invoiceNo} (${DateFormat('dd/MM/yyyy').format(inv.invoiceDate)}) - ₹${inv.grandTotal.toStringAsFixed(2)}',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              final match = _customerInvoices
                                  .where((i) => i.id == val)
                                  .firstOrNull;
                              if (match != null) {
                                _onOriginalInvoiceSelected(
                                  match,
                                  prefillLines:
                                      _selectedType == InvoiceType.credit_note,
                                );
                              }
                            } else {
                              setState(() {
                                _selectedOriginalInvoiceId = null;
                                _originalInvoice = null;
                                _remainingCreditableAmount = 0.0;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: isDesktop ? 220 : double.infinity,
                        child: AppSelect<NoteReason?>(
                          label: 'Reason *',
                          value: _selectedNoteReason,
                          items: NoteReason.values
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r.displayName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedNoteReason = val);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: isDesktop ? 300 : double.infinity,
                        child: TextFormField(
                          controller: _noteReasonTextController,
                          decoration: const InputDecoration(
                            labelText: 'Reason Remarks (Optional)',
                            helperText: 'Additional context for this note',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedType == InvoiceType.credit_note &&
                      _selectedOriginalInvoiceId != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade800,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Remaining Creditable Limit: ₹${_remainingCreditableAmount.toStringAsFixed(2)} (Original: ₹${_originalInvoice?.grandTotal.toStringAsFixed(2) ?? "0"})',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_selectedType == InvoiceType.credit_note &&
                      _selectedNoteReason == NoteReason.sales_return &&
                      _items.any((i) => i.type == ItemSourceType.copperStock)) ...[
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Add returned quantity back to stock'),
                      subtitle: const Text(
                        'Creates a sales_return_in movement to increment inventory',
                      ),
                      value: _returnStockToInventory,
                      onChanged: (val) =>
                          setState(() => _returnStockToInventory = val ?? false),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          _selectedType.isCreditNote ? 'Credit Note Dates & Terms' : (_selectedType.isDebitNote ? 'Debit Note Dates & Terms' : 'Invoice Dates & Terms'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) {
            final todayFY = FinancialYear.getFinancialStartYear(DateTime.now());
            final invFY = FinancialYear.getFinancialStartYear(_invoiceDate);
            final isDifferentFY = invFY != todayFY;
            final fyLabel = 'FY $invFY-${(invFY + 1).toString().substring(2)}';
            final isOlderThan30Days = _invoiceDate.isBefore(IstDateUtils.nowIst().subtract(const Duration(days: 30)));
            final isFutureInvoice = _invoiceDate.isAfter(IstDateUtils.nowIst());

            final isNoteBeforeOrig = _selectedType.isNote &&
                _originalInvoice != null &&
                IstDateUtils.toMidnightIst(_invoiceDate).isBefore(IstDateUtils.toMidnightIst(_originalInvoice!.invoiceDate));

            bool isAfterGstDeadline = false;
            int fyEndYear = 0;
            if (_selectedType == InvoiceType.credit_note && _originalInvoice != null) {
              final origDate = _originalInvoice!.invoiceDate;
              fyEndYear = origDate.month >= 4 ? origDate.year + 1 : origDate.year;
              final gstDeadline = DateTime(fyEndYear, 11, 30, 23, 59, 59);
              isAfterGstDeadline = _invoiceDate.isAfter(gstDeadline);
            }

            if (!isDifferentFY && !isOlderThan30Days && !isFutureInvoice && !isNoteBeforeOrig && !isAfterGstDeadline) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isNoteBeforeOrig ? Colors.red.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isNoteBeforeOrig ? Colors.red.shade300 : Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNoteBeforeOrig)
                      Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade900, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note date cannot be before original invoice date (${DateFormat('dd/MM/yyyy').format(_originalInvoice!.invoiceDate)})',
                              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    if (isAfterGstDeadline) ...[
                      if (isNoteBeforeOrig) const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note date is after 30 November $fyEndYear following original invoice FY end — this may be past the GST time limit. Confirm with your CA.',
                              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w600, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isDifferentFY)
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber.shade900, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Invoice date is in a different financial year — number series changed to $fyLabel',
                              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w500, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    if (isOlderThan30Days) ...[
                      if (isDifferentFY) const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Invoice date is more than 30 days in the past',
                              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w500, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isFutureInvoice) ...[
                      if (isDifferentFY || isOlderThan30Days) const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.amber.shade900, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Invoice is future-dated',
                              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w500, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDateField(
                label: 'Invoice Date *',
                value: _invoiceDate,
                enabled: _isInvoiceNoEditable,
                isRequired: true,
                onChanged: (picked) {
                  if (picked != null) {
                    setState(() {
                      _invoiceDate = IstDateUtils.toMidnightIst(picked);
                      if (!_isDueDateManuallyOverridden &&
                          _paymentTermDays != null &&
                          _paymentTermDays! > 0) {
                        _dueDate = _invoiceDate.add(
                          Duration(days: _paymentTermDays!),
                        );
                      }
                    });
                    if (!_isInvoiceNoManuallyEdited && _isInvoiceNoEditable) {
                      _fetchNextInvoiceNumber();
                    }
                  }
                },
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
                        _isDueDateManuallyOverridden = false;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: AppDateField(
                label: 'Due Date',
                value: _dueDate,
                enabled: _isInvoiceNoEditable,
                onChanged: (picked) {
                  setState(() {
                    _dueDate = picked != null ? IstDateUtils.toMidnightIst(picked) : null;
                    _isDueDateManuallyOverridden = true;
                  });
                },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: 'PO Number',
                controller: _poNumberController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppDateField(
                label: 'PO Date',
                value: _poDate,
                enabled: _isInvoiceNoEditable,
                onChanged: (picked) {
                  setState(() {
                    _poDate = picked != null ? IstDateUtils.toMidnightIst(picked) : null;
                  });
                },
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
              child: AppDateField(
                label: 'GP Date',
                value: _gpDate,
                enabled: _isInvoiceNoEditable,
                onChanged: (picked) {
                  setState(() {
                    _gpDate = picked != null ? IstDateUtils.toMidnightIst(picked) : null;
                  });
                },
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
                  defaultMotorHsn: defaultMotorHsn,
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
            if (_selectedType == InvoiceType.serviceTaxInvoice ||
                _selectedType == InvoiceType.deliveryChallan) ...[
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
              if (_taxMode == TaxMode.igst_only) ...[
                _buildSummaryRow('IGST:', totals.igstAmount),
              ] else ...[
                _buildSummaryRow('CGST:', totals.cgstAmount),
                _buildSummaryRow('SGST:', totals.sgstAmount),
              ],
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
            if (_selectedType == InvoiceType.credit_note && _selectedOriginalInvoiceId != null) ...[
              const Divider(),
              _buildSummaryRow('Creditable Limit:', _remainingCreditableAmount),
              if (totals.grandTotal > _remainingCreditableAmount + 0.001)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Exceeds Limit by:',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '₹${(totals.grandTotal - _remainingCreditableAmount).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13).mono,
                      ),
                    ],
                  ),
                ),
            ],
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
    final companyAsync = ref.watch(companySettingsStreamProvider);
    final companyState = _getCompanyState(companyAsync.value);

    final showGst =
        _selectedType != InvoiceType.billOfSupply &&
        _selectedType != InvoiceType.deliveryChallan &&
        !(_selectedType.isNote && _originalInvoice?.invoiceType == InvoiceType.billOfSupply);
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
      taxMode: _taxMode,
      deliveryCharge: _deliveryCharge,
      isOriginalBillOfSupply:
          _selectedType.isNote &&
          _originalInvoice?.invoiceType == InvoiceType.billOfSupply,
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
                          widget.invoiceId != null
                              ? (_selectedType.isCreditNote
                                  ? 'Edit Credit Note'
                                  : (_selectedType.isDebitNote
                                      ? 'Edit Debit Note'
                                      : 'Edit Invoice'))
                              : (_selectedType.isCreditNote
                                  ? 'New Credit Note'
                                  : (_selectedType.isDebitNote
                                      ? 'New Debit Note'
                                      : 'New Invoice')),
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
                                  companyState,
                                  defaultMotorHsn: companyAsync.value?.defaultMotorHsn,
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
                                companyState,
                                defaultMotorHsn: companyAsync.value?.defaultMotorHsn,
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
