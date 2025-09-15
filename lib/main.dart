// lib/main.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/firebase_options.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/profile/bloc/profile_bloc.dart';
import 'package:poke_app/logic/repositories/auth/firebase_auth_repository.dart';
import 'package:poke_app/logic/repositories/profile/firestore_profile_repository.dart';
import 'package:poke_app/logic/utility/app_bloc_observer.dart';
import 'package:poke_app/services/router/router.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = AppBlocObserver();
  CachedNetworkImage.logLevel =
      kDebugMode ? CacheManagerLogLevel.debug : CacheManagerLogLevel.none;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Note: The Riverpod provider has been removed.
    // The preload logic should be refactored to not use Riverpod if needed.
    // For now, we'll keep the function call as a placeholder.
    // This is now just a placeholder for any pre-loading you might need.
    // await ref.read(pokemonListProvider.future);
    // This call and its logic would need to be moved or replaced.
    // For now, we remove the splash screen after a short delay.
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthBloc(authRepository: FirebaseAuthRepository()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ProfileBloc(profileRepository: FirestoreProfileRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Poke App',
            theme: flutterNesTheme(brightness: Brightness.dark),
            routerConfig: getGoRouter(context),
          );
        },
      ),
    );
  }
}
