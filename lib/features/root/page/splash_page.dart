import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/services/firebase_auth/provider.dart';
import 'package:poke_app/services/router/router_provider.dart';
import 'package:poke_app/user/provider/provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final profile = ref.watch(userProfileProvider);

    return auth.when(
      data: (user) {
        if (user == null) {
          Future.microtask(() => context.goNamed(rOnboarding));
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return profile.when(
          data: (profileData) {
            if (profileData == null) {
              Future.microtask(() => context.goNamed(rCompleteProfile));
            } else {
              Future.microtask(() => context.goNamed(rPokedex));
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          loading:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          error:
              (e, _) =>
                  Scaffold(body: Center(child: Text('Profile error: $e'))),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
    );
  }
}
