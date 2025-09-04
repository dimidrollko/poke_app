import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/bloc/sign_in/cubit/cubit/login_form_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.signInKey});
  final GlobalKey signInKey;

  @override
  build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return NesButton(
          type: NesButtonType.primary,
          key: signInKey,
          onPressed: () {
            if (state.isValid) {
              context.read<AuthBloc>().add(
                AuthSignInRequested(
                  email: state.email.value,
                  password: state.password.value,
                ),
              );
            }
          },
          child: const Text('Sign In'),
        );
      },
    );
  }
}
