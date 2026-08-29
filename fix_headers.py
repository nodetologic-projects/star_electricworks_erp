with open('lib/features/billing/pdf/invoice_pdf.dart', 'r') as f:
    content = f.read()

content = content.replace('headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black)', 'headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black, fontSize: 8.5)')

with open('lib/features/billing/pdf/invoice_pdf.dart', 'w') as f:
    f.write(content)
print("Done")
