import 'package:json_annotation/json_annotation.dart';
part 'poke_stat.g.dart';

enum StatType {
  hp,
  attack,
  defense,
  speed,
  unknown;

  static StatType fromName(String name) {
    return StatType.values.firstWhere(
      (t) => t.name == name.toLowerCase(),
      orElse: () => unknown,
    );
  }
}

@JsonSerializable()
class PokemonStat {
  @JsonKey(name: 'base_stat')
  final int baseStat;
  final Map<String, dynamic> stat;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final StatType type;

  PokemonStat({required this.baseStat, required this.stat}) {
    type = StatType.fromName(stat['name'] as String);
  }

  factory PokemonStat.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonStatToJson(this);
}
