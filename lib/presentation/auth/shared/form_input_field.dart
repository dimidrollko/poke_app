import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class FormInputField<T extends FormzInput<String, dynamic>> extends StatelessWidget {
  final T input;
  final ValueChanged<String> onChanged;
  final String label;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;

  const FormInputField({
    super.key,
    required this.input,
    required this.onChanged,
    required this.label,
    this.obscureText = false,
    this.focusNode,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        errorText: input.displayError?.trext(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
