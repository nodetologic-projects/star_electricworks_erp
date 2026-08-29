import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """      final invoiceId = await repo.createInvoiceWithItems(
        invoiceCompanion,
        itemCompanions,
      );"""

patch = """      int savedInvoiceId = 0;
      if (widget.invoiceId != null) {
        await repo.updateInvoiceWithItems(widget.invoiceId!, invoiceCompanion, itemCompanions);
        savedInvoiceId = widget.invoiceId!;
      } else {
        savedInvoiceId = await repo.createInvoiceWithItems(
          invoiceCompanion,
          itemCompanions,
        );
      }"""

if target not in content:
    print("Target not found or already patched")
    sys.exit(0)

new_content = content.replace(target, patch)

target_quotation = """      if (widget.sourceQuotationId != null) {
        final quotesRepo = ref.read(quotationsRepositoryProvider);
        await quotesRepo.markConverted(widget.sourceQuotationId!, invoiceId);
      }"""

patch_quotation = """      if (widget.sourceQuotationId != null && widget.invoiceId == null) {
        final quotesRepo = ref.read(quotationsRepositoryProvider);
        await quotesRepo.markConverted(widget.sourceQuotationId!, savedInvoiceId);
      }"""

new_content = new_content.replace(target_quotation, patch_quotation)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(new_content)

print("Patched save")
