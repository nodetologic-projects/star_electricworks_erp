import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    lines = f.readlines()

new_lines = []
for i, line in enumerate(lines):
    # 133: if (existingInvoice == null) return;
    if "if (existingInvoice == null) return;" in line:
        continue
    # 149: if (existingCustomer != null) {
    if "if (existingCustomer != null) {" in line:
        continue
    # 151: _customerAddressController.text = existingCustomer.address ?? '';
    # Wait, existingCustomer.address might NOT be nullable?
    if "_customerAddressController.text = existingCustomer.address" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    if "_customerStateController.text = existingCustomer.state" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    if "_customerGstinController.text = existingCustomer.gstin" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    if "_customerPhoneController.text = existingCustomer.phone" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    if "_customerEmailController.text = existingCustomer.email" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    if "_customerVendorCodeController.text = existingCustomer.vendorCode" in line:
        new_lines.append(line.replace(" ?? ''", ""))
        continue
    # removing closing brace of if (existingCustomer != null)
    if line.strip() == "}" and "existingCustomer" in lines[i-1]:
        # Wait, the closing brace is a few lines down. Let's just fix it differently.
        pass
    new_lines.append(line)

content = "".join(new_lines)
# Remove the closing brace of the if block
content = content.replace("          _customerVendorCodeController.text = existingCustomer.vendorCode;\n        }\n", "          _customerVendorCodeController.text = existingCustomer.vendorCode;\n")

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)

