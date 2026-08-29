import re

with open('lib/features/billing/pdf/invoice_pdf.dart', 'r') as f:
    content = f.read()

# Remove isService
content = re.sub(r"\s*final bool isService = type == InvoiceType\.serviceTaxInvoice;\n", "\n", content)

# Remove _buildServiceTable
pattern = r"  static pw\.Widget _buildServiceTable\(.*?\)\s*\{\n.*?return pw\.TableHelper\.fromTextArray\(.*?\);\n  \}\n"
content = re.sub(pattern, "", content, flags=re.DOTALL)

with open('lib/features/billing/pdf/invoice_pdf.dart', 'w') as f:
    f.write(content)
print("Done")
