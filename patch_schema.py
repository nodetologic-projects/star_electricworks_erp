import sys

with open("lib/data/database.dart", "r") as f:
    content = f.read()

# Change schemaVersion to 19
content = content.replace("int get schemaVersion => 18;", "int get schemaVersion => 19;")

# Add migration logic
target = "try { await m.createTable(companySettings); } catch (_) {}"
patch = """try { await m.createTable(companySettings); } catch (_) {}
        }
        if (from < 19) {
          try { await m.addColumn(invoiceItems, invoiceItems.rateRs); } catch (_) {}"""

content = content.replace(target, patch)

with open("lib/data/database.dart", "w") as f:
    f.write(content)
