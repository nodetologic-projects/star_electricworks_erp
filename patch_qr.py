import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target = "static pw.Widget _buildFooter("

patch = """static pw.Widget _buildFooter(
    CompanySetting company,
    Invoice invoice,
    double totalPaid,
  ) {
    print('DIAGNOSTICS - _buildFooter called');
    print('DIAGNOSTICS - company.upiId: "${company.upiId}"');
    print('DIAGNOSTICS - invoice.grandTotal: ${invoice.grandTotal}');
    print('DIAGNOSTICS - totalPaid: $totalPaid');

    final bool shouldShowQr = company.upiId != null && company.upiId!.isNotEmpty && (invoice.grandTotal - totalPaid) > 0;
    print('DIAGNOSTICS - QR condition evaluates to: $shouldShowQr');
"""

content = content.replace("  static pw.Widget _buildFooter(\n    CompanySetting company,\n    Invoice invoice,\n    double totalPaid,\n  ) {", patch)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)

