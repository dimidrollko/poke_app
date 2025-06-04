import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
part 'poke_type.g.dart';

final Map<PokemonType, Color> typeColors = {
  PokemonType.normal: Color(0xFFA8A77A),
  PokemonType.fighting: Color(0xFFC22E28),
  PokemonType.flying: Color(0xFFA98FF3),
  PokemonType.poison: Color(0xFFA33EA1),
  PokemonType.ground: Color(0xFFE2BF65),
  PokemonType.rock: Color(0xFFB6A136),
  PokemonType.bug: Color(0xFFA6B91A),
  PokemonType.ghost: Color(0xFF735797),
  PokemonType.steel: Color(0xFFB7B7CE),
  PokemonType.fire: Color(0xFFEE8130),
  PokemonType.water: Color(0xFF6390F0),
  PokemonType.grass: Color(0xFF7AC74C),
  PokemonType.electric: Color(0xFFF7D02C),
  PokemonType.psychic: Color(0xFFF95587),
  PokemonType.ice: Color(0xFF96D9D6),
  PokemonType.dragon: Color(0xFF6F35FC),
  PokemonType.dark: Color(0xFF705746),
  PokemonType.fairy: Color(0xFFD685AD),
  PokemonType.stellar: Color(0xFF4A90E2),
  PokemonType.unknown: Color(0xFFAAAAAA),
  PokemonType.shadow: Color(0xFF333333),
};

enum PokemonType {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  stellar,
  unknown,
  shadow;

  static PokemonType fromName(String name) {
    return PokemonType.values.firstWhere(
      (t) => t.name == name.toLowerCase(),
      orElse: () => PokemonType.unknown,
    );
  }
}

@JsonSerializable()
class TypeSlot {
  final int slot;
  final Map<String, dynamic> type;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final PokemonType pokemonType;

  TypeSlot({required this.slot, required this.type}) {
    pokemonType = PokemonType.fromName(type['name'] as String);
  }
  factory TypeSlot.fromJson(Map<String, dynamic> json) =>
      _$TypeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$TypeSlotToJson(this);
}
