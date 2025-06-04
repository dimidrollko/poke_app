import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/pokedex/components/pokemon_stat_chip.dart';
import 'package:poke_app/features/pokedex/data/poke_type.dart';
import 'package:poke_app/features/pokedex/data/pokemon_details.dart';
import 'package:poke_app/features/pokedex/data/pokemon_model.dart';
import 'package:poke_app/features/pokedex/provider/pokemons_provider.dart';
import 'package:poke_app/user/provider/provider.dart';

class PokemonCard extends ConsumerWidget {
  final PokemonBase pokemon;

  const PokemonCard({super.key, required this.pokemon});

  List<Color> getGradientColorsForTypes(PokemonDetail? detail) {
    final defaultColor = typeColors[PokemonType.unknown]!;
    if (detail?.types.isEmpty ?? true) return List.filled(4, defaultColor);

    final colors =
        detail!.types
            .take(2)
            .map((e) => typeColors[e.pokemonType] ?? defaultColor)
            .toList();

    return colors.length == 1
        ? List.filled(4, colors.first)
        : [colors[0], colors[0], colors[1], colors[1]];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileStreamProvider);

    final userProfile = userProfileAsync.asData?.value;
    final isDiscovered =
        userProfile?.discoveredEntities.any(
          (entry) => entry.id == pokemon.id,
        ) ??
        false;

    final detail =
        isDiscovered
            ? ref.watch(pokemonDetailsProvider(pokemon.id)).asData?.value
            : null;

    return Container(
      height: 128,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  tileMode: TileMode.decal,
                  colors: getGradientColorsForTypes(detail),
                  stops: const [0.0, 0.7, 0.7, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 22,
                  margin: const EdgeInsets.symmetric(horizontal: 64),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      detail != null
                          ? Text(pokemon.name.toUpperCase())
                          : const Text('Catch It!'),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Stack(
                        children: [
                          Transform.rotate(
                            angle: 5 * pi / 6,
                            child: SvgPicture.asset(
                              'assets/images/pokeball.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          detail != null
                              ? CachedNetworkImage(
                                imageUrl: pokemon.imageUrl,
                                placeholder:
                                    (context, url) =>
                                        const CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                              )
                              : ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: pokemon.imageUrl,
                                  placeholder:
                                      (context, url) =>
                                          const CircularProgressIndicator(),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                              ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StatChip(
                                label: 'ATK',
                                value: detail?.attack.toString() ?? '?',
                                color: const Color(0xFFFF5CA0C7),
                              ),
                              Gaps.w8,
                              StatChip(
                                label: 'HP',
                                value: detail?.hp.toString() ?? '?',
                                color: const Color(0xFFFFE35F9C),
                              ),
                            ],
                          ),
                          Gaps.h4,
                          Row(
                            children: [
                              Gaps.w16,
                              StatChip(
                                label: 'DEF',
                                value: detail?.defense.toString() ?? '?',
                                color: const Color(0xFFB6B658),
                              ),
                              Gaps.w8,
                              StatChip(
                                label: 'SPD',
                                value: detail?.speed.toString() ?? '?',
                                color: const Color(0xFFFF7AC74C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
