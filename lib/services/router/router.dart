// go_router_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/features/auth/pages/complete_profile_page.dart';
import 'package:poke_app/features/guess_game/page/guess_pokemon_page.dart';
import 'package:poke_app/features/root/page/splash_page.dart';
import 'package:poke_app/features/tabbar/page/tab_bar_page.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/profile/bloc/profile_bloc.dart';
import 'package:poke_app/presentation/auth/signin/sign_in_screen.dart';
import 'package:poke_app/services/router/bloc_router_notifier.dart';

// Route constants
const String rSplash = '/';
const String rOnboarding = '/auth/test_quiz';
const String rSignIn = '/auth/signin';
const String rSignUp = '/auth/signup';
const String rCompleteProfile = '/auth/complete-profile';
const String rPokedex = '/pokedex';
const String rQuiz = '/quiz';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> authNavigator = GlobalKey(
  debugLabel: 'auth_shell',
);
final GlobalKey<NavigatorState> mainNavigator = GlobalKey(
  debugLabel: 'main_shell',
);

GoRouter getGoRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();
  final profileBloc = context.read<ProfileBloc>();

  return GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: rSplash,
    debugLogDiagnostics: true,
    refreshListenable: BlocRouterNotifier(authBloc, profileBloc),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final profileState = profileBloc.state;
      final isGoingToAuth = state.fullPath?.startsWith('/auth') ?? false;

      // Unauthenticated users can only go to auth pages.
      if (authState is AuthUnauthenticated) {
        return isGoingToAuth ? null : rSignIn;
      }
      // Receiving Error or Loading state should left on current flow
      if (authState is AuthLoading || authState is AuthError) {
        return null;
      }
      // Authenticated but profile not completed.
      if (authState is AuthAuthenticated) {
        if (profileState is ProfileNotCompleted) {
          return rCompleteProfile;
        }
      }

      // Authenticated and profile is completed.
      if (authState is AuthAuthenticated && profileState is ProfileLoaded) {
        // Redirect from auth pages to the main app.
        return isGoingToAuth ? rPokedex : null;
      }
      // Keep user on splash screen while states are loading.
      if (authState is AuthInitial || profileState is ProfileInitial) {
        return rSplash;
      }

      return null; // No redirect needed.
    },
    routes: [
      GoRoute(
        path: rSplash,
        name: rSplash,
        builder: (context, state) => const SplashPage(),
      ),
      ShellRoute(
        navigatorKey: authNavigator,
        builder: (context, state, child) => Scaffold(body: child),
        routes: [
          GoRoute(
            path: rOnboarding,
            name: rOnboarding,
            builder: (context, state) => GuessPokemonPage(isTutorial: true),
          ),
          GoRoute(
            path: rSignIn,
            name: rSignIn,
            builder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            path: rSignUp,
            name: rSignUp,
            builder: (context, state) {
              final tutorialData = state.extra as Map<String, dynamic>?;
              return CompleteProfilePage(); // SignUpPage(tutorialData: tutorialData);
            },
          ),
          GoRoute(
            path: rCompleteProfile,
            name: rCompleteProfile,
            builder: (context, state) {
              final tutorialData = state.extra as Map<String, dynamic>?;
              return CompleteProfilePage(tutorialData: tutorialData);
            },
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: mainNavigator,
        builder: (context, state, child) => Scaffold(body: child),
        routes: [
          GoRoute(
            path: rPokedex,
            name: rPokedex,
            builder: (context, state) => const MainTabbedPage(),
          ),
          GoRoute(
            path: rQuiz,
            name: rQuiz,
            builder: (context, state) => const GuessPokemonPage(),
          ),
        ],
      ),
    ],
  );
}
