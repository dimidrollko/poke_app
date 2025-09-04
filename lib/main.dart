import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/features/pokedex/provider/pokemons_provider.dart';
import 'package:poke_app/firebase_options.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/repositories/auth/firebase_auth_repository.dart';
import 'package:poke_app/logic/utility/app_bloc_observer.dart';
import 'package:poke_app/presentation/auth/signin/sign_in_screen.dart';
import 'package:poke_app/services/router/router_provider.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = AppBlocObserver();
  CachedNetworkImage.logLevel =
      kDebugMode ? CacheManagerLogLevel.debug : CacheManagerLogLevel.none;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.signOut();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await ref.read(pokemonListProvider.future);
    } catch (e, st) {
      debugPrint('Preload failed: $e\n$st');
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthBloc(authRepository: FirebaseAuthRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Poke App',
        theme: flutterNesTheme(brightness: Brightness.dark),
        home: const SignInPage(),
      ),
    );
  }
}
