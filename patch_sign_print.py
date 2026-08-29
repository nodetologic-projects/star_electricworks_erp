import sys

with open("lib/features/billing/screens/invoice_detail_screen.dart", "r") as f:
    content = f.read()

patch = """
  Future<void> _signAndPrint(BuildContext context, InvoiceDetailData data) async {
    print("ACTION: Sign & Print button pressed");
    
    // If already signed, just print
    if (data.invoice.signedPdfPath != null && data.invoice.signedPdfPath!.isNotEmpty) {
      print("INFO: Invoice already signed (path: ${data.invoice.signedPdfPath}), skipping to print step");
      await _executePrintStep(context, data);
      return;
    }

    print("ACTION: Starting Sign step...");
    final success = await _signAndFinalize(context, data);
    print("RESULT: Sign step returned success=$success");
    
    if (success) {
      print("ACTION: Starting Print step...");
      if (context.mounted) {
        await _executePrintStep(context, data);
      } else {
        print("ERROR: Cannot execute print step - context is no longer mounted after signing");
      }
    } else {
      print("INFO: Skipping Print step because Sign step failed or was cancelled");
    }
  }

  Future<void> _executePrintStep(BuildContext context, InvoiceDetailData data) async {
    try {
      print("ACTION: Calling DirectPrintService.printPdf");
      await DirectPrintService.printPdf(
        context,
        data.invoice.invoiceNo,
        fallbackGenerate: () => InvoicePdfGenerator.generate(
          copyLabels: [_selectedCopyType],
          company: data.companySetting,
          invoice: data.invoice,
          items: data.items,
          customer: data.customer,
          totalPaid: data.payments.fold<double>(0, (s, p) => s + p.amount),
        )
      );
      print("RESULT: Print step completed (check DirectPrintService logs for success/failure)");
    } catch (e, stack) {
      print("ERROR: Print step threw an exception: $e\\n$stack");
    }
  }
"""

# Replace the existing _signAndPrint method
# We need to find the start of _signAndPrint and its end
start_idx = content.find("  Future<void> _signAndPrint(BuildContext context, InvoiceDetailData data) async {")
end_idx = content.find("  Future<bool> _signAndFinalize(BuildContext context, InvoiceDetailData data) async {")

if start_idx != -1 and end_idx != -1:
    content = content[:start_idx] + patch.strip() + "\n\n" + content[end_idx:]
    with open("lib/features/billing/screens/invoice_detail_screen.dart", "w") as f:
        f.write(content)
    print("Successfully patched _signAndPrint")
else:
    print("Could not find _signAndPrint or _signAndFinalize")
