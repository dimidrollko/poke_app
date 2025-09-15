import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/profile/bloc/profile_bloc.dart';
import 'package:poke_app/services/router/router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated) {
          context.goNamed(rSignIn);
        }
      },
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return BlocListener<ProfileBloc, ProfileState>(
            listener: (context, profileState) {
              if (profileState is ProfileNotCompleted) {
                context.goNamed(rCompleteProfile);
              } else if (profileState is ProfileLoaded) {
                context.goNamed(rPokedex);
              }
            },
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
