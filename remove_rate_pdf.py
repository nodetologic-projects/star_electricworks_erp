import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target1 = """    final headers = [
      'Description',
      'Rate/RS',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      if (showGst) 'Total\\n(incl. GST)' else 'Total',
    ];"""

patch1 = """    final headers = [
      'Description',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      if (showGst) 'Total\\n(incl. GST)' else 'Total',
    ];"""

content = content.replace(target1, patch1)

target2 = """      return [
        _buildDescriptionWidget(item.description),
        pw.Text(item.rateRs ?? '', style: pw.TextStyle(font: monoFont)),
        if (!isDeliveryChallan) item.hsnCode ?? '',"""

patch2 = """      return [
        _buildDescriptionWidget(item.description),
        if (!isDeliveryChallan) item.hsnCode ?? '',"""

content = content.replace(target2, patch2)

target3 = """    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
      6: pw.Alignment.centerRight,
    };"""

patch3 = """    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
    };"""

content = content.replace(target3, patch3)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)
