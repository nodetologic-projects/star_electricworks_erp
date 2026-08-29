import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = "line.description = item.description;"
patch = "line.description = item.description;\n          line.rateRs = item.rateRs;"

content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)
