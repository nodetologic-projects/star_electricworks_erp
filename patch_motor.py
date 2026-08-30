import sys

with open("lib/features/motor_jobs/screens/motor_job_form_screen.dart", "r") as f:
    content = f.read()

target1 = """                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Job Description *',
                              hintText: 'Describe the work to be done...',
                              controller: _jobDescController,
                              maxLines: 4,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Job description is required'
                                  : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.format_bold),
                            tooltip: 'Bold Selected Text',
                            onPressed: () {
                              final ctrl = _jobDescController;
                              final text = ctrl.text;
                              final selection = ctrl.selection;
                              if (selection.isValid && selection.start != selection.end) {
                                final selected = text.substring(selection.start, selection.end);
                                final newText = text.replaceRange(selection.start, selection.end, '**$selected**');
                                ctrl.value = ctrl.value.copyWith(
                                  text: newText,
                                  selection: TextSelection.collapsed(offset: selection.start + selected.length + 4),
                                );
                              } else {
                                final cursor = selection.isValid ? selection.start : text.length;
                                final newText = text.replaceRange(cursor, cursor, '****');
                                ctrl.value = ctrl.value.copyWith(
                                  text: newText,
                                  selection: TextSelection.collapsed(offset: cursor + 2),
                                );
                              }
                            },
                          ),
                        ],
                      ),"""

patch1 = """                      RichTextInput(
                        label: 'Job Description *',
                        hintText: 'Describe the work to be done...',
                        controller: _jobDescController,
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Job description is required'
                            : null,
                      ),"""

target2 = """                      AppTextField(
                        label: 'Motor Description *',
                        hintText: 'e.g. 10HP 3-phase induction motor',
                        controller: _motorDescController,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Description is required'
                            : null,
                      ),"""

patch2 = """                      RichTextInput(
                        label: 'Motor Description *',
                        hintText: 'e.g. 10HP 3-phase induction motor',
                        controller: _motorDescController,
                        maxLines: 2,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Description is required'
                            : null,
                      ),"""

if target1 in content:
    content = content.replace(target1, patch1)
    if target2 in content:
        content = content.replace(target2, patch2)
        
    if "import 'package:starelectricerp/core/widgets/rich_text_input.dart';" not in content:
        content = content.replace(
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';",
            "import 'package:starelectricerp/core/widgets/app_text_field.dart';\nimport 'package:starelectricerp/core/widgets/rich_text_input.dart';"
        )
    with open("lib/features/motor_jobs/screens/motor_job_form_screen.dart", "w") as f:
        f.write(content)
    print("Patched motor_job_form_screen.dart")
else:
    print("Could not find target1 in motor_job_form_screen.dart")
