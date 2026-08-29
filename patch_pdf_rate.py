import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target = """    final headers = [
      'Description',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      'Total',
    ];

    final data = items.map((item) {
      return [
        _buildDescriptionWidget(item.description),
        if (!isDeliveryChallan) item.hsnCode ?? '',
        pw.Text(
          item.qty?.toString() ?? '1',
          style: pw.TextStyle(font: monoFont),
        ),
        pw.Text(
          item.unitPrice.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
        if (showGst)
          pw.Text('${item.gstRate ?? 0}%', style: pw.TextStyle(font: monoFont)),
        pw.Text(
          item.lineTotal.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
      ];
    }).toList();"""

patch = """    final headers = [
      'Description',
      'Rate/RS',
      if (!isDeliveryChallan) 'SAC/HSN',
      'Qty',
      'Rate',
      if (showGst) 'GST%',
      'Total',
    ];

    final data = items.map((item) {
      return [
        _buildDescriptionWidget(item.description),
        pw.Text(item.rateRs ?? '', style: pw.TextStyle(font: monoFont)),
        if (!isDeliveryChallan) item.hsnCode ?? '',
        pw.Text(
          item.qty?.toString() ?? '1',
          style: pw.TextStyle(font: monoFont),
        ),
        pw.Text(
          item.unitPrice.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
        if (showGst)
          pw.Text('${item.gstRate ?? 0}%', style: pw.TextStyle(font: monoFont)),
        pw.Text(
          item.lineTotal.toStringAsFixed(2),
          style: pw.TextStyle(font: monoFont),
        ),
      ];
    }).toList();"""

content = content.replace(target, patch)

# Now fix alignments
target2 = """    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
    };

    if (isDeliveryChallan) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      };
    } else if (!showGst) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      };
    }"""

patch2 = """    Map<int, pw.Alignment> alignments = {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
      6: pw.Alignment.centerRight,
    };

    if (isDeliveryChallan) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      };
    } else if (!showGst) {
      alignments = {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      };
    }"""

content = content.replace(target2, patch2)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)
