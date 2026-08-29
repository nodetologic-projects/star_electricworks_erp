import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """            child: Text(
              '₹${item.lineTotal.toStringAsFixed(2)}',"""

patch = """            child: Text(
              '₹${(showGst ? (item.lineTotal * (1 + ((item.gstRate ?? 0) / 100))) : item.lineTotal).toStringAsFixed(2)}',"""

content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)
