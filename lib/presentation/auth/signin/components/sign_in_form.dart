// lib/presentation/auth/signin/components/sign_in_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/pokedex/data/poke_stat.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/bloc/sign_in/cubit/cubit/signin_form_cubit.dart';
import 'package:poke_app/presentation/auth/shared/email_input_field.dart';
import 'package:poke_app/presentation/auth/signin/components/login_button.dart';
import 'package:poke_app/presentation/auth/shared/password_input_field.dart';
import 'package:poke_app/services/router/router.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _signInKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    for (var node in [_emailNode, _passwordNode]) {
      node.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if ([_emailNode, _passwordNode].any((e) => e.hasFocus)) {
      Future.delayed(const Duration(milliseconds: 400), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _signInKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 1.0,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo_pokemon.png',
                        width: double.infinity,
                      ),
                    ),
                    BlocBuilder<SignInFormCubit, SignInFormState>(
                      builder: (context, state) {
                        return EmailInputField(
                          focusNode: _emailNode,
                          email: state.email,
                          onChanged:
                              context.read<SignInFormCubit>().emailChanged,
                        );
                      },
                    ),
                    Gaps.h16,
                    BlocBuilder<SignInFormCubit, SignInFormState>(
                      builder: (context, state) {
                        return PasswordInputField(
                          focusNode: _passwordNode,
                          password: state.password,
                          onChanged:
                              context.read<SignInFormCubit>().passwordChanged,
                        );
                      },
                    ),
                    Gaps.h24,
                    LoginButton(signInKey: _signInKey),
                    Gaps.h4,
                    const Center(child: Text('Or')),
                    Gaps.h4,
                    // GoogleSignInButton(),
                    const Divider(),
                    NesButton(
                      type: NesButtonType.normal,
                      onPressed: () {
                        context.goNamed(rSignUp);
                      },
                      child: const Text(
                        'Don\'t have an account?\nSign up',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state is AuthLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
