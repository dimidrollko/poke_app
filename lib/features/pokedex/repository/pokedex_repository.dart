import 'dart:convert';

import 'package:poke_app/features/pokedex/data/pokemon_details.dart';
import 'package:poke_app/features/pokedex/data/pokemon_model.dart';
import 'package:poke_app/services/api/api_service.dart';
import 'package:poke_app/services/api/data/api_list_response.dart';
import 'package:poke_app/services/db/db_service.dart';
import 'package:sqflite/sqflite.dart';

class _Constants {
  static const String pokemonPath = '/pokemon';
  static const String pokemonDetailPath = '/pokemon/{id}';
}

abstract class PokedexRepository {
  /// Fetches a list of Pokemons without pagination.
  Future<List<PokemonBase>> getAllPokemons();
  Future<List<PokemonBase>> getDiscoveredPokemons(List<int> discoveredIds);
  Future<int> getPokemonsCount();
  Future<PokemonDetail> getPokemonDetailById(int id);
  //Saving
  Future<void> saveBasePokemons(List<PokemonBase> pokemons);
  Future<void> savePokemonDetail(PokemonDetail detail);
  Future<List<PokemonBase>> getRandomQuizOptions(int? correctId);
}

class PokedexRepositoryApiImpl implements PokedexRepository {
  final APIService _api;

  PokedexRepositoryApiImpl(this._api);

  @override
  Future<List<PokemonBase>> getAllPokemons() async {
    final int total = await getPokemonsCount();
    final result = await _api.get(
      _Constants.pokemonPath,
      queryParams: {"limit": total.toString()},
      fromJson:
          (json) => ApiListResponse<PokemonBase>.fromJson(
            json,
            (item) => PokemonBase.fromJson(item as Map<String, dynamic>),
          ),
    );
    return result.results;
  }

  @override
  Future<List<PokemonBase>> getDiscoveredPokemons(
    List<int> discoveredIds,
  ) async {
    final list = await getAllPokemons();
    final discoveredSet = discoveredIds.toSet(); // O(1) lookup
    return list.where((e) => discoveredSet.contains(e.id)).toList();
  }

  @override
  Future<int> getPokemonsCount() async {
    // Fetch the total count of Pokemons from the API
    // API send error if limit == 0, so we use limit = 1 to get the count
    final listResponse = await _api.get<ApiListResponse<PokemonBase>>(
      _Constants.pokemonPath,
      queryParams: {'limit': '1'},
      fromJson:
          (json) => ApiListResponse.fromJson(
            json,
            (item) => PokemonBase.fromJson(item as Map<String, dynamic>),
          ),
    );
    return listResponse.count;
  }

  @override
  Future<PokemonDetail> getPokemonDetailById(int id) {
    return _api.get<PokemonDetail>(
      _Constants.pokemonDetailPath.replaceFirst('{id}', id.toString()),
      fromJson: PokemonDetail.fromJson,
    );
  }

  @override
  Future<void> saveBasePokemons(List<PokemonBase> pokemons) {
    return Future.value();
  }

  @override
  Future<void> savePokemonDetail(PokemonDetail detail) {
    return Future.value();
  }

  @override
  Future<List<PokemonBase>> getRandomQuizOptions(int? correctId) {
    //We can randomly select here any of pokemon id's
    //currently ids separated to two: from 1-1024, and then numerations starts from 10000
    //As we have local db, we don't need directly use API
    //WIP
    return Future.value(List.empty());
  }
}

class PokedexRepositoryDbImpl implements PokedexRepository {
  final DbService dbService;
  PokedexRepositoryDbImpl(this.dbService);

  // This implementation would interact with a local database

  @override
  Future<List<PokemonBase>> getAllPokemons() async {
    final db = await dbService.database;
    final maps = await db.query('base_pokemon');
    return maps
        .map(
          (e) => PokemonBase(
            name: e['name'] as String,
            url:
                'https://pokeapi.co/api/v2/pokemon/${e['id']}', //Hardcoded URL for simplicity
          ),
        )
        .toList();
  }

  /// Fetch only discovered Pokémon based on the given list of IDs
  @override
  Future<List<PokemonBase>> getDiscoveredPokemons(
    List<int> discoveredIds,
  ) async {
    if (discoveredIds.isEmpty) return [];

    final db = await dbService.database;

    // Create a comma-separated list of question marks for the WHERE IN clause
    final whereClause =
        'id IN (${List.filled(discoveredIds.length, '?').join(',')})';

    final maps = await db.query(
      'base_pokemon',
      where: whereClause,
      whereArgs: discoveredIds,
    );

    return maps
        .map(
          (e) => PokemonBase(
            name: e['name'] as String,
            url: 'https://pokeapi.co/api/v2/pokemon/${e['id']}',
          ),
        )
        .toList();
  }

  @override
  Future<List<PokemonBase>> getRandomQuizOptions(int? correctId) async {
    final db = await dbService.database;

    final List<Map<String, dynamic>> correct =
        correctId != null
            ? await db.query(
              'base_pokemon',
              where: 'id = ?',
              whereArgs: [correctId],
              limit: 1,
            )
            : [];

    // Execute the raw SQL query to fetch 4 random Pokemons
    final List<Map<String, dynamic>> random = await db.rawQuery(
      """SELECT * FROM base_pokemon 
      ${correctId != null ? "WHERE id != ?" : ""}
      ORDER BY RANDOM() 
      LIMIT ${correctId != null ? 3 : 4}
      """,
      correctId != null ? [correctId] : [],
    );
    final all = [...correct, ...random];

    // Map the result to a list of PokemonBase
    //First will be correct
    return all
        .map(
          (e) => PokemonBase(
            name: e['name'] as String,
            url: 'https://pokeapi.co/api/v2/pokemon/${e['id']}',
          ),
        )
        .toList();
  }

  @override
  Future<int> getPokemonsCount() async {
    final db = await dbService.database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM base_pokemon'),
    );
    return result ?? 0;
  }

  @override
  Future<PokemonDetail> getPokemonDetailById(int id) async {
    final db = await dbService.database;
    final result = await db.query(
      'detail_pokemon',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Pokemon detail not found for id: $id');
    }
    final detail = PokemonDetail.fromDbMap(result.first);
    return detail;
  }

  @override
  Future<void> saveBasePokemons(List<PokemonBase> pokemons) async {
    final db = await dbService.database;
    final batch = db.batch();
    for (final p in pokemons) {
      batch.insert('base_pokemon', {
        'id': p.id,
        'name': p.name,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> savePokemonDetail(PokemonDetail detail) async {
    final db = await dbService.database;
    final batch = db.batch();
    batch.insert('detail_pokemon', {
      'id': detail.id,
      'hp': detail.hp,
      'attack': detail.attack,
      'speed': detail.speed,
      'defense': detail.defense,
      'types': jsonEncode(detail.types.map((e) => e.toJson()).toList()),
      'stats': jsonEncode(detail.stats.map((e) => e.toJson()).toList()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: false);
  }
}
