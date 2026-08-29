import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _invoiceDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  setState(() => _invoiceDate = date);
                                }
                              },"""

patch = """                              onTap: widget.invoiceId != null ? null : () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _invoiceDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  setState(() => _invoiceDate = date);
                                }
                              },"""

if patch in content:
    print("Already patched datepicker")
else:
    content = content.replace(target, patch)
    with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
        f.write(content)
    print("Patched datepicker")

