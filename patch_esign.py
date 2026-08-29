import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target = """              pw.SizedBox(height: 50),
              pw.Text(
                'AUTHORIZED SIGNATORY',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 60), // space for stamp/signature"""

patch = """              pw.SizedBox(height: 50),
              pw.Text(
                'AUTHORIZED SIGNATORY',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '(e-Signed)',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 40), // space for stamp/signature"""

content = content.replace(target, patch)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)
