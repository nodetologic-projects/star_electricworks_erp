import sys

with open("lib/features/billing/screens/invoice_detail_screen.dart", "r") as f:
    content = f.read()

target = """                          DropdownButton<String>("""

patch = """                          if (data.invoice.status == InvoiceStatus.draft)
                            ElevatedButton.icon(
                              onPressed: () => context.push('/invoices/edit/${data.invoice.id}'),
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Invoice'),
                            )
                          else
                            Tooltip(
                              message: "Finalized invoices can't be edited — create a credit note or new invoice for corrections instead.",
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Invoice'),
                              ),
                            ),
                          const SizedBox(width: 8),
                          DropdownButton<String>("""

if "Edit Invoice" in content:
    print("Already patched")
    sys.exit(0)

new_content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_detail_screen.dart", "w") as f:
    f.write(new_content)

print("Patched detail screen")
