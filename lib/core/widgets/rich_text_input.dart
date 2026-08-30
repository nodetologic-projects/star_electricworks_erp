import 'package:flutter/material.dart';

class RichTextInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const RichTextInput({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.validator,
    this.onChanged,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotEmpty) ...[
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              TextFormField(
                controller: controller,
                validator: validator,
                onChanged: onChanged,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                  labelText: label.isEmpty ? null : null, // keep label outside
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.format_bold),
          tooltip: 'Bold Selected Text',
          onPressed: () {
            final text = controller.text;
            final selection = controller.selection;
            if (selection.isValid && selection.start != selection.end) {
              final selected = text.substring(selection.start, selection.end);
              final newText = text.replaceRange(selection.start, selection.end, '**$selected**');
              controller.value = controller.value.copyWith(
                text: newText,
                selection: TextSelection.collapsed(offset: selection.start + selected.length + 4),
              );
              if (onChanged != null) onChanged!(newText);
            } else {
              final cursor = selection.isValid ? selection.start : text.length;
              final newText = text.replaceRange(cursor, cursor, '****');
              controller.value = controller.value.copyWith(
                text: newText,
                selection: TextSelection.collapsed(offset: cursor + 2),
              );
              if (onChanged != null) onChanged!(newText);
            }
          },
        ),
      ],
    );
  }
}
