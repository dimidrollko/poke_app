import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:poke_app/features/pokedex/data/poke_stat.dart';
import 'package:poke_app/features/pokedex/data/poke_type.dart';
part 'pokemon_details.g.dart';

@JsonSerializable()
class PokemonDetail {
  final List<PokemonStat> stats;
  final List<TypeSlot> types;
  final int id;

  int get hp => stats.firstWhere((s) => s.type == StatType.hp).baseStat;
  int get attack => stats.firstWhere((s) => s.type == StatType.attack).baseStat;
  int get speed => stats.firstWhere((s) => s.type == StatType.speed).baseStat;
  int get defense =>
      stats.firstWhere((s) => s.type == StatType.defense).baseStat;

  PokemonDetail({required this.id, required this.stats, required this.types});

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);

  factory PokemonDetail.fromDbMap(Map<String, dynamic> map) {
    var stats = <PokemonStat>[];
    for (var type in StatType.values) {
      final typeName = type.name;
      //get value from map[typename], if not found skip adding to stats
      if (!map.containsKey(typeName)) continue;
      stats.add(PokemonStat(baseStat: map[typeName], stat: {"name": typeName}));
    }

    return PokemonDetail(
      id: map['id'] as int,
      stats: stats,
      types:
          (jsonDecode(map['types']) as List<dynamic>)
              .map((e) => TypeSlot.fromJson(e))
              .toList(),
    );
  }
}
