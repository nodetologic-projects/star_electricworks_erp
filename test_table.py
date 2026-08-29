with open('lib/features/billing/pdf/invoice_pdf.dart', 'r') as f:
    content = f.read()

content = content.replace('cellHeight: 30', 'cellHeight: 20')

if 'cellStyle: const pw.TextStyle(fontSize: 8)' not in content:
    content = content.replace('cellAlignments: alignments,', 'cellAlignments: alignments,\n      cellStyle: const pw.TextStyle(fontSize: 8),')

with open('lib/features/billing/pdf/invoice_pdf.dart', 'w') as f:
    f.write(content)
print("Done")
