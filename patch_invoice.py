import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('desc_${index}_${item.linkedId}'),
                        controller: item.descController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Custom Description',
                        ),
                        onChanged: (val) => item.description = val,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.format_bold),
                      tooltip: 'Bold Selected Text',
                      onPressed: () {
                        final ctrl = item.descController!;
                        final text = ctrl.text;
                        final selection = ctrl.selection;
                        if (selection.isValid && selection.start != selection.end) {
                          final selected = text.substring(selection.start, selection.end);
                          final newText = text.replaceRange(selection.start, selection.end, '**$selected**');
                          ctrl.value = ctrl.value.copyWith(
                            text: newText,
                            selection: TextSelection.collapsed(offset: selection.start + selected.length + 4),
                          );
                          item.description = newText;
                        } else {
                           // If no selection, just insert ** ** at cursor
                           final cursor = selection.isValid ? selection.start : text.length;
                           final newText = text.replaceRange(cursor, cursor, '****');
                           ctrl.value = ctrl.value.copyWith(
                             text: newText,
                             selection: TextSelection.collapsed(offset: cursor + 2),
                           );
                           item.description = newText;
                        }
                      },
                    ),
                  ],
                ),"""

patch = """              : RichTextInput(
                  key: ValueKey('desc_${index}_${item.linkedId}'),
                  label: 'Custom Description',
                  controller: item.descController!,
                  maxLines: 4,
                  onChanged: (val) => item.description = val,
                ),"""

if target in content:
    content = content.replace(target, patch)
    
    # Also we need to import RichTextInput
    if "import 'package:starelectricerp/core/widgets/rich_text_input.dart';" not in content:
        content = content.replace(
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';",
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';\nimport 'package:starelectricerp/core/widgets/rich_text_input.dart';"
        )
    
    with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
        f.write(content)
    print("Patched invoice_form_screen.dart")
else:
    print("Could not find target in invoice_form_screen.dart")
