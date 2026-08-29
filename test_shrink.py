import re

with open('lib/features/billing/pdf/invoice_pdf.dart', 'r') as f:
    content = f.read()

# Scale font sizes
def scale_fonts(match):
    size = float(match.group(1))
    if size >= 16:
        new_size = size - 2
    elif size == 12:
        new_size = 10
    elif size == 11:
        new_size = 9
    elif size == 10:
        new_size = 8
    elif size == 9:
        new_size = 7.5
    elif size == 8:
        new_size = 7
    else:
        new_size = size - 1
    return f'fontSize: {int(new_size) if new_size.is_integer() else new_size}'

content = re.sub(r'fontSize:\s*([\d.]+)', scale_fonts, content)

# Scale paddings & margins
content = content.replace('pw.EdgeInsets.all(6)', 'pw.EdgeInsets.all(4)')
content = content.replace('pw.EdgeInsets.all(4)', 'pw.EdgeInsets.all(3)')
content = content.replace('pw.EdgeInsets.symmetric(vertical: 4)', 'pw.EdgeInsets.symmetric(vertical: 2)')
content = content.replace('pw.SizedBox(height: 16)', 'pw.SizedBox(height: 10)')
content = content.replace('pw.SizedBox(height: 8)', 'pw.SizedBox(height: 4)')
content = content.replace('pw.SizedBox(height: 4)', 'pw.SizedBox(height: 2)')

# Keep _buildTotalsLine bold slightly larger. In python we can just fix it explicitly.
content = content.replace('fontSize: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9', 'fontSize: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: isBold ? 10 : 8.5')
content = content.replace('isBold ? monoFontBold : monoFont, fontSize: 9', 'isBold ? monoFontBold : monoFont, fontSize: isBold ? 10 : 8.5')

with open('lib/features/billing/pdf/invoice_pdf.dart', 'w') as f:
    f.write(content)
print("Done")
