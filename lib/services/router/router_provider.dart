// go_router_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/features/auth/pages/complete_profile_page.dart';
import 'package:poke_app/features/auth/pages/sign_in_page.dart';
import 'package:poke_app/features/auth/pages/sign_up_page.dart';
import 'package:poke_app/features/guess_game/page/guess_pokemon_page.dart';
import 'package:poke_app/features/pokedex/pages/pokedex_page.dart';
import 'package:poke_app/features/root/page/splash_page.dart';
import 'package:poke_app/features/tabbar/page/tab_bar_page.dart';
import 'package:poke_app/services/firebase_auth/provider.dart';

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
String? lastPage;

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: rSplash,
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
              return SignUpPage(tutorialData: tutorialData);
            },
          ),
          GoRoute(
            path: rCompleteProfile,
            name: rCompleteProfile,
            builder: (context, state) {
              final tutorialData = state.extra as Map<String, dynamic>?;
              return CompleteProfilePage(tutorialData: tutorialData,);
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
});
