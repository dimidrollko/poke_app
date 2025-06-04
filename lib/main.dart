import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:poke_app/features/pokedex/provider/pokemons_provider.dart';
import 'package:poke_app/firebase_options.dart';
import 'package:poke_app/services/router/router_provider.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Poke App',
      theme: flutterNesTheme(brightness: Brightness.dark),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
