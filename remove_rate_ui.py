import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

# 1. Remove from _LineItem class
content = content.replace("  String? rateRs;\n", "")

# 2. Remove from _loadExistingInvoice
content = content.replace("          line.rateRs = item.rateRs;\n", "")

# 3. Remove from _saveInvoice (InvoiceItemsCompanion.insert)
content = content.replace("          rateRs: drift.Value(i.rateRs),\n", "")

# 4. Remove UI field
ui_target = """        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: TextFormField(
            key: ValueKey('raters_${index}_${item.linkedId}'),
            initialValue: item.rateRs ?? '',
            decoration: const InputDecoration(labelText: 'Rate/RS'),
            onChanged: (val) => item.rateRs = val,
          ),
        ),"""

content = content.replace(ui_target, "")

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)
