import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

# I will replace from `        pw.Row(\n          crossAxisAlignment: pw.CrossAxisAlignment.start,`
# to the end of `_buildHeaderBlock`.

start_idx = content.find("        pw.Row(\n          crossAxisAlignment: pw.CrossAxisAlignment.start,")
end_idx = content.find("      ],\n    );\n  }\n\n  static pw.Widget _buildMetaRow", start_idx)

if start_idx == -1 or end_idx == -1:
    print("Could not find block")
    sys.exit(1)

old_block = content[start_idx:end_idx]

patch = """        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left: Company Info
            pw.Expanded(
              child: pw.Container(
                height: 140,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      company.companyName,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      company.address,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Ph: ${company.phone}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'Email: ${company.email}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Bank: ${company.bankName}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'A/C: ${company.bankAccountNo}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.Text(
                      'IFSC: ${company.bankIfsc}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'GSTIN: ${company.gstin}',
                      style: pw.TextStyle(
                        fontSize: 7.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (company.gstin.length == 15)
                      pw.Text(
                        'PAN: ${company.gstin.substring(2, 12)}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                  ],
                ),
              ),
            ),
            // Middle: Bill To
            pw.Expanded(
              child: pw.Container(
                height: 140,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: const pw.Border(
                    top: pw.BorderSide(width: 0.5),
                    bottom: pw.BorderSide(width: 0.5),
                    right: pw.BorderSide(width: 0.5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      isPurchase ? 'Purchased From:' : 'Bill To:',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      customer.name,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      customer.address,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    if (customer.gstin != null && customer.gstin!.isNotEmpty)
                      pw.Text(
                        'GSTIN: ${customer.gstin}',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (customer.vendorCode != null &&
                        customer.vendorCode!.isNotEmpty)
                      pw.Text(
                        'Vendor Code: ${customer.vendorCode}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                    if (invoice.placeOfSupply != null &&
                        invoice.placeOfSupply!.isNotEmpty)
                      pw.Text(
                        'Place of Supply: ${invoice.placeOfSupply}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                    if (invoice.paymentTermDays != null) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Payment Term: ${invoice.paymentTermDays} Days',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Right: Ship To
            pw.Expanded(
              child: pw.Container(
                height: 140,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: const pw.Border(
                    top: pw.BorderSide(width: 0.5),
                    bottom: pw.BorderSide(width: 0.5),
                    right: pw.BorderSide(width: 0.5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Ship To:',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      shipToName,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      shipToAddress,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                    if (customer.gstin != null && customer.gstin!.isNotEmpty)
                      pw.Text(
                        'GSTIN: ${customer.gstin}',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (customer.vendorCode != null &&
                        customer.vendorCode!.isNotEmpty)
                      pw.Text(
                        'Vendor Code: ${customer.vendorCode}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),
                  ],
                ),
              ),
            ),
          ],
        )"""

new_content = content[:start_idx] + patch + content[end_idx:]

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(new_content)

print("Patched header block successfully")
