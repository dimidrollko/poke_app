import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:poke_app/logic/cubit/bloc/sign_in/cubit/cubit/login_form_cubit.dart';
import 'package:poke_app/logic/formz/password_form.dart';

class PasswordInputField extends StatelessWidget {
  bool showPassword = true;
  final FocusNode focusNode;

  PasswordInputField({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      buildWhen: (previous, current) => current.password != previous.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) {
            context.read<LoginFormCubit>().passwordChanged(value);
          },
          obscureText: showPassword,

          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: (() {
                showPassword = !showPassword;
              }),
            ),
            labelText: 'Password',
            errorText: state.password.displayError?.text(),
          ),
        );
      },
    );
  }
}
