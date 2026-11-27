//lib/widgets/character/common/form_input.dart

import 'package:material_ui/material_ui.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  final bool isInteger;
  final int? minValue;

  const FormInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = false,
    this.isInteger = false,
    this.minValue,
  });

  String? _validate(String? value) {
    final text = value?.trim() ?? '';

    if (isRequired && text.isEmpty) {
      return 'This field is required';
    }

    if (text.isEmpty || !isInteger) {
      return null;
    }

    final number = int.tryParse(text);

    if (number == null) {
      return 'Enter a valid number';
    }

    if (minValue != null && number < minValue!) {
      return 'Minimum value is $minValue';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: _validate,
    );
  }
}
