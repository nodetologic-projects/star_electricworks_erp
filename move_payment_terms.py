import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

# 1. Move it from Middle to Left
middle_payment_term = """                    if (invoice.paymentTermDays != null) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Payment Term: ${invoice.paymentTermDays} Days',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],"""

if middle_payment_term in content:
    content = content.replace(middle_payment_term, "")
    
    # Put it at the bottom of the Left column
    target_left_bottom = """                    if (company.gstin.length == 15)
                      pw.Text(
                        'PAN: ${company.gstin.substring(2, 12)}',
                        style: const pw.TextStyle(fontSize: 7.5),
                      ),"""
    
    if target_left_bottom in content:
        content = content.replace(target_left_bottom, target_left_bottom + "\n" + middle_payment_term)

# 2. Remove the old one at the bottom of the PDF
old_bottom_payment_term = """              if (invoice.paymentTermDays != null) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  'Payment Terms: Pay within ${invoice.paymentTermDays} days of bill generation',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                    color: PdfColors.black,
                  ),
                ),
              ],"""

if old_bottom_payment_term in content:
    content = content.replace(old_bottom_payment_term, "")

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)

print("Moved payment terms")
