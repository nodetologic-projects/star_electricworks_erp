import 'package:flutter/material.dart';
import 'package:starelectricerp/core/gstin_validator.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';

class GstinInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const GstinInputField({
    super.key,
    required this.controller,
    this.label = 'GSTIN',
  });

  @override
  State<GstinInputField> createState() => _GstinInputFieldState();
}

class _GstinInputFieldState extends State<GstinInputField> {
  String? _errorText;
  bool _overrideValidation = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validate();
    }
  }

  void _validate() {
    setState(() {
      _errorText = GstinValidator.validateStructure(widget.controller.text);
      if (_errorText == null) {
        _overrideValidation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: widget.label,
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: (val) {
            final cursorPos = widget.controller.selection;
            final upper = val.toUpperCase();
            if (val != upper) {
              widget.controller.value = TextEditingValue(
                text: upper,
                selection: cursorPos,
              );
            }
          },
          validator: (val) {
            final error = GstinValidator.validateStructure(val);
            if (error != null && !_overrideValidation) {
              // We return null here if we want to rely entirely on the warning box, 
              // but standard forms expect a string to block submission.
              // Instead of standard red error text which duplicates our box,
              // we can return a generic message or just use the box.
              // Returning an empty string blocks the form but doesn't double-render the message
              // since AppTextField might show it. Let's return the error so the standard form catches it.
              return 'Please verify the GSTIN format warnings above.';
            }
            return null; 
          },
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _overrideValidation,
                        onChanged: (val) {
                          setState(() {
                            _overrideValidation = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('I\'ve verified this is correct', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
