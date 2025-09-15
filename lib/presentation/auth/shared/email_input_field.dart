import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/logic/formz/email_form.dart';
import 'package:poke_app/presentation/auth/shared/form_input_field.dart';

class EmailInputField extends StatelessWidget {
  final Email email;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  const EmailInputField({
    super.key,
    required this.email,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FormInputField<Email>(
      input: email,
      onChanged: onChanged,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      focusNode: focusNode,
    );
  }
}
