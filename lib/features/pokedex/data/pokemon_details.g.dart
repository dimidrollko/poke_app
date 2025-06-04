// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PokemonDetail _$PokemonDetailFromJson(Map<String, dynamic> json) =>
    PokemonDetail(
      id: (json['id'] as num).toInt(),
      stats:
          (json['stats'] as List<dynamic>)
              .map((e) => PokemonStat.fromJson(e as Map<String, dynamic>))
              .toList(),
      types:
          (json['types'] as List<dynamic>)
              .map((e) => TypeSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PokemonDetailToJson(PokemonDetail instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'types': instance.types,
      'id': instance.id,
    };
