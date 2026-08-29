import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target = """    final headers = [
      'Description',
      'Rate/RS',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      'Total',
    ];"""

patch = """    final headers = [
      'Description',
      'Rate/RS',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      if (showGst) 'Total\\n(incl. GST)' else 'Total',
    ];"""

content = content.replace(target, patch)

target2 = """        pw.Text(
          item.lineTotal.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),"""

patch2 = """        pw.Text(
          (showGst ? (item.lineTotal * (1 + (item.gstRate ?? 0) / 100)) : item.lineTotal).toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),"""

content = content.replace(target2, patch2)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)
