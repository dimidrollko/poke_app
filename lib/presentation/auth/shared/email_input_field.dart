import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_app/logic/cubit/bloc/sign_in/cubit/cubit/login_form_cubit.dart';
import 'package:poke_app/logic/formz/email_form.dart';

class EmailInputField extends StatelessWidget {
  final FocusNode focusNode;
  const EmailInputField({
    super.key,
    required this.focusNode,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      buildWhen: (previous, current) => current.email != previous.email,
      builder: (context, state) {
        return TextFormField(
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onChanged,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText:
                state.email.isValid ? null : state.email.displayError?.text(),
          ),
        );
      },
    );
  }
}
