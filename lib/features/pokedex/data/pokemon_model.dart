import 'package:json_annotation/json_annotation.dart';
part 'pokemon_model.g.dart';

@JsonSerializable()
class PokemonBase {
  final String name;
  final String url;

  @JsonKey(includeFromJson: false, includeToJson: true)
  int get id {
    return int.parse(url.split('/').lastWhere((segment) => segment.isNotEmpty));
  }

  String get imageUrl {
    // Using the id to construct the image URL
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  PokemonBase({required this.name, required this.url});
  factory PokemonBase.fromJson(Map<String, dynamic> json) =>
      _$PokemonBaseFromJson(json);
}
