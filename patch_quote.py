import sys

with open("lib/features/quotations/screens/quotation_form_screen.dart", "r") as f:
    content = f.read()

target = """                      AppTextField(
                        controller: _descCtrl,
                        label: 'Description / Scope of Work',
                        hintText: 'Rewinding of 10HP Motor...',
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),"""

patch = """                      RichTextInput(
                        controller: _descCtrl,
                        label: 'Description / Scope of Work',
                        hintText: 'Rewinding of 10HP Motor...',
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),"""

if target in content:
    content = content.replace(target, patch)
    
    if "import 'package:starelectricerp/core/widgets/rich_text_input.dart';" not in content:
        content = content.replace(
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';",
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';\nimport 'package:starelectricerp/core/widgets/rich_text_input.dart';"
        )
    with open("lib/features/quotations/screens/quotation_form_screen.dart", "w") as f:
        f.write(content)
    print("Patched quotation_form_screen.dart")
else:
    print("Could not find target in quotation_form_screen.dart")
