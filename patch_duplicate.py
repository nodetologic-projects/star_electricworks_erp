import sys

with open("lib/data/repositories/invoices_repository.dart", "r") as f:
    content = f.read()

target = """  Future<Invoice?> findDuplicateInvoice({
    required int customerId,
    required InvoiceType type,
    required double grandTotal,
    required DateTime date,
  }) async {"""

patch = """  Future<Invoice?> findDuplicateInvoice({
    required int customerId,
    required InvoiceType type,
    required double grandTotal,
    required DateTime date,
    int? excludeInvoiceId,
  }) async {"""

if patch in content:
    print("Already patched findDuplicateInvoice signature")
else:
    content = content.replace(target, patch)

target2 = """      ..where((t) => t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBiggerOrEqualValue(cutoff));"""

patch2 = """      ..where((t) => t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBiggerOrEqualValue(cutoff));
    if (excludeInvoiceId != null) {
      query.where((t) => t.id.isNotValue(excludeInvoiceId));
    }"""

if "excludeInvoiceId != null" in content:
    print("Already patched findDuplicateInvoice body")
else:
    content = content.replace(target2, patch2)

with open("lib/data/repositories/invoices_repository.dart", "w") as f:
    f.write(content)

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    form_content = f.read()

target3 = """      final duplicate = await repo.findDuplicateInvoice(
        customerId: finalCustomerId,
        type: _selectedType,
        grandTotal: totals.grandTotal,
        date: DateTime.now(),
      );"""

patch3 = """      final duplicate = await repo.findDuplicateInvoice(
        customerId: finalCustomerId,
        type: _selectedType,
        grandTotal: totals.grandTotal,
        date: DateTime.now(),
        excludeInvoiceId: widget.invoiceId,
      );"""

if patch3 in form_content:
    print("Already patched form")
else:
    form_content = form_content.replace(target3, patch3)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(form_content)

print("Patched duplicate check")
