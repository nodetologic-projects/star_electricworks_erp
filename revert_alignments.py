import sys

with open("lib/features/billing/pdf/invoice_pdf.dart", "r") as f:
    content = f.read()

target = """    if (isDeliveryChallan) {
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

patch = """    if (isDeliveryChallan) {
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

content = content.replace(target, patch)

with open("lib/features/billing/pdf/invoice_pdf.dart", "w") as f:
    f.write(content)
