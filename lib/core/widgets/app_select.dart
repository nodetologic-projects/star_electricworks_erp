import 'package:flutter/material.dart';

class AppSelect<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? Function(T?)? validator;

  const AppSelect({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }
}
