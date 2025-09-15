import 'package:flutter/material.dart';
import 'package:poke_app/logic/formz/password_form.dart';

class PasswordInputField extends StatefulWidget {
  final Password password;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  const PasswordInputField({
    super.key,
    required this.password,
    required this.onChanged,
    this.focusNode,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: widget.password.displayError?.text(),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ),
    );
  }
}
