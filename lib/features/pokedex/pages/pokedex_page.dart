import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/features/pokedex/components/pokemon_card.dart';
import 'package:poke_app/features/pokedex/provider/pokemons_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';

final showDiscoveredOnlyProvider = StateProvider<bool>((ref) => false);

class PokemonListPage extends ConsumerWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDiscoveredOnly = ref.watch(showDiscoveredOnlyProvider);
    final asyncValue = ref.watch(
      showDiscoveredOnly ? discoveredPokemonsProvider : pokemonListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
            icon: Icon(
              showDiscoveredOnly ? Icons.filter_list : Icons.filter_list_off,
            ),
            tooltip: showDiscoveredOnly ? 'Show All' : 'Show Discovered Only',
            onPressed: () {
              ref.read(showDiscoveredOnlyProvider.notifier).state =
                  !showDiscoveredOnly;
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: asyncValue.when(
          data:
              (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];
                  return PokemonCard(pokemon: p);
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(horizontal: 40),
        onPressed: () {
          context.push(rQuiz);
          // You can define any action here
        },
        label: const Text('Catch Them All'),
        icon: SvgPicture.asset(
          'assets/images/pokeball_colored.svg',
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
