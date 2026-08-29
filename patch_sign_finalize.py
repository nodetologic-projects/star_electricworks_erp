import sys

with open("lib/features/billing/screens/invoice_detail_screen.dart", "r") as f:
    content = f.read()

target = "      if (error == null) {"
patch = """      print("RESULT of DscSigner (null means success): $error");
      
      if (error == null) {"""

content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_detail_screen.dart", "w") as f:
    f.write(content)
