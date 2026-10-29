import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';

/// Formatter that automatically inserts slashes for dd/MM/yyyy date input.
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handling backspace / deletions:
    if (newValue.text.length < oldValue.text.length) {
      // If user deleted the slash, also remove the digit before it
      if (oldValue.text.endsWith('/') && !newValue.text.endsWith('/')) {
        final stripped = newValue.text.isNotEmpty
            ? newValue.text.substring(0, newValue.text.length - 1)
            : '';
        return TextEditingValue(
          text: stripped,
          selection: TextSelection.collapsed(offset: stripped.length),
        );
      }
      return newValue;
    }

    // Extract only digits
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Limit to 8 digits (DDMMYYYY)
    final clamped = digits.length > 8 ? digits.substring(0, 8) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < clamped.length; i++) {
      buffer.write(clamped[i]);
      if (i == 1 || i == 3) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// A shared, standardized date input widget supporting both manual dd/MM/yyyy text typing
/// (with auto-inserted slashes) and selection via a calendar picker dialog.
/// Automatically normalizes values to date-only midnight IST.
class AppDateField extends StatefulWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final bool enabled;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDateField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late TextEditingController _controller;
  bool _isInternalChange = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? IstDateUtils.format(widget.value) : '',
    );
  }

  @override
  void didUpdateWidget(AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isInternalChange && widget.value != oldWidget.value) {
      final newText = widget.value != null ? IstDateUtils.format(widget.value) : '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    if (!widget.enabled) return;

    final initial = widget.value ?? IstDateUtils.nowIst();
    final first = widget.firstDate ?? DateTime(1970);
    final last = widget.lastDate ?? DateTime(2100);

    final safeInitial = initial.isBefore(first)
        ? first
        : (initial.isAfter(last) ? last : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      final normalized = IstDateUtils.toMidnightIst(picked);
      _isInternalChange = true;
      _controller.text = IstDateUtils.format(normalized);
      _isInternalChange = false;
      widget.onChanged?.call(normalized);
    }
  }

  void _onTextChanged(String text) {
    if (!widget.enabled) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      _isInternalChange = true;
      widget.onChanged?.call(null);
      _isInternalChange = false;
      return;
    }

    if (trimmed.length == 10) {
      final parsed = IstDateUtils.parse(trimmed);
      if (parsed != null) {
        _isInternalChange = true;
        widget.onChanged?.call(parsed);
        _isInternalChange = false;
      }
    }
  }

  String? _validate(String? val) {
    if (widget.validator != null) {
      final customRes = widget.validator!(val);
      if (customRes != null) return customRes;
    }

    final trimmed = val?.trim() ?? '';
    if (widget.isRequired && trimmed.isEmpty) {
      return 'Required';
    }

    if (trimmed.isNotEmpty) {
      if (trimmed.length < 10) {
        return 'Incomplete date (DD/MM/YYYY)';
      }
      final parsed = IstDateUtils.parse(trimmed);
      if (parsed == null) {
        return 'Invalid date (e.g. no 31/02)';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.enabled ? null : theme.disabledColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
            DateInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            helperText: widget.helperText,
            errorText: widget.errorText,
            suffixIcon: IconButton(
              icon: Icon(
                widget.enabled ? Icons.calendar_today_outlined : Icons.lock_outline,
                size: 18,
                color: widget.enabled ? theme.colorScheme.primary : theme.disabledColor,
              ),
              tooltip: widget.enabled ? 'Pick Date' : 'Locked',
              onPressed: widget.enabled ? _pickDate : null,
            ),
          ),
          onChanged: _onTextChanged,
          validator: _validate,
        ),
      ],
    );
  }
}
