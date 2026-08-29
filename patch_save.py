import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = "description: drift.Value(item.description),"
patch = "description: drift.Value(item.description),\n        rateRs: drift.Value(item.rateRs),"

content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)
