import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/bloc/sign_in/cubit/cubit/signin_form_cubit.dart';
import 'package:poke_app/presentation/auth/signin/components/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: BlocProvider(
          create: (_) => SignInFormCubit(),
          child: const SignInForm(),
        ),
      ),
    );
  }
}
