import re

with open('lib/features/reports/services/ca_export_service.dart', 'r') as f:
    content = f.read()

content = content.replace("import 'package:path/path.dart' as p;\n", "")
content = content.replace("import 'package:starelectricerp/data/tables/invoices.dart';\n", "")

with open('lib/features/reports/services/ca_export_service.dart', 'w') as f:
    f.write(content)
print("Done")
