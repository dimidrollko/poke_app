import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/features/guess_game/data/starter_pack.dart';
import 'package:poke_app/features/pokedex/data/pokemon_details.dart';
import 'package:poke_app/features/pokedex/data/pokemon_model.dart';
import 'package:poke_app/features/pokedex/repository/pokedex_repository.dart';
import 'package:poke_app/services/api/api_provider.dart';
import 'package:poke_app/services/db/db_provider.dart';
import 'package:poke_app/user/provider/provider.dart';

final pokedexDbProvider = Provider<PokedexRepository>((ref) {
  return PokedexRepositoryDbImpl(ref.read(dbServiceProvider));
});

final pokedexRepositoryProvider = Provider<PokedexRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return PokedexRepositoryApiImpl(api);
});

final pokemonListProvider = FutureProvider<List<PokemonBase>>((ref) async {
  final db = ref.read(pokedexDbProvider);
  final api = ref.read(pokedexRepositoryProvider);
  final dbCount = await db.getPokemonsCount();
  final apiCount = await api.getPokemonsCount();
  if (dbCount != apiCount) {
    if (kDebugMode) {
      debugPrint('Pokemons count mismatch: DB: $dbCount, API: $apiCount');
    }
    final pokemons = await api.getAllPokemons();
    await db.saveBasePokemons(pokemons);
    return pokemons;
  }
  return db.getAllPokemons();
});

final discoveredPokemonsProvider = FutureProvider<List<PokemonBase>>((
  ref,
) async {
  final db = ref.read(pokedexDbProvider);
  final userProfile = ref.watch(userProfileStreamProvider).asData?.value;

  final discoveredIds =
      userProfile?.discoveredEntities.map((e) => e.id).toList() ?? [];
  return db.getDiscoveredPokemons(discoveredIds);
});

final pokemonDetailsProvider = FutureProvider.family<PokemonDetail, int>((
  ref,
  id,
) async {
  final db = ref.read(pokedexDbProvider);
  final api = ref.read(pokedexRepositoryProvider);
  try {
    final dbDetail = await db.getPokemonDetailById(id);
    return dbDetail;
  } catch (e, _) {
    final apiDetail = await api.getPokemonDetailById(id);
    await db.savePokemonDetail(apiDetail);
    return apiDetail;
  }
});

class QuizNotifier extends AsyncNotifier<List<PokemonBase>> {
  int? correctId;

  @override
  Future<List<PokemonBase>> build() async {
    // Attempt to use starter ID if in tutorial mode
    return [];
  }

  Future<void> loadNewQuestion(int? id) async {
    correctId = id;
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(pokedexDbProvider).getRandomQuizOptions(id),
    );
  }
}
final quizNotifierProvider =
    AsyncNotifierProvider<QuizNotifier, List<PokemonBase>>(
      () => QuizNotifier(),
    );
