import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/guess_game/data/starter_pack.dart';
import 'package:poke_app/features/pokedex/data/pokemon_model.dart';
import 'package:poke_app/features/pokedex/provider/pokemons_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';
import 'package:poke_app/user/provider/provider.dart';

class GuessPokemonPage extends ConsumerStatefulWidget {
  final bool isTutorial;

  const GuessPokemonPage({super.key, this.isTutorial = false});

  @override
  ConsumerState<GuessPokemonPage> createState() => _GuessPokemonPageState();
}

class _GuessPokemonPageState extends ConsumerState<GuessPokemonPage> {
  DateTime? startTime;
  String? selectedName;
  late StarterPokemon? starter;
  PokemonBase? correctOption;
  List<PokemonBase>? shuffledOptions;
  bool hasImageError = false;

  bool isCorrect = false;
  bool showFeedback = false;
  bool isWaitingForDiscovery = false;
  late AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    _player.setReleaseMode(ReleaseMode.stop);

    starter = widget.isTutorial ? StarterPokemon.any() : null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reloadQuestion();
      await _player.setSource(AssetSource('sounds/whos_that_pokemon.mp3'));
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    _player.dispose();
    super.dispose();
  }

  Future<void> submitAnswer({
    required int entityId,
    required double duration,
    required bool isCorrect,
  }) async {
    final functions = FirebaseFunctions.instanceFor(region: 'europe-central2');
    final callable = functions.httpsCallable('recordDiscovery');

    await callable.call({
      'entity_id': entityId,
      'duration': duration,
      'is_correct': isCorrect,
    });
  }

  void reloadQuestion() {
    correctOption = null;
    shuffledOptions = null;
    startTime = null;
    selectedName = null;
    showFeedback = false;
    hasImageError = false;
    isCorrect = false;
    isWaitingForDiscovery = false;
    ref.read(quizNotifierProvider.notifier).loadNewQuestion(starter?.id);
  }

  void onOptionSelected(String selected) {
    final isTutorial = widget.isTutorial;
    if (selectedName != null) return;
    final duration = DateTime.now().difference(startTime!);
    if (isTutorial) {
      if (correctOption?.name != selected) return;
      final tutorialData = {
        'id': correctOption!.id,
        'duration': duration.inMilliseconds / 1000,
      };
      selectedName = selected;
      isCorrect = true;
      showFeedback = true;
      setState(() {});
      Future.delayed(const Duration(seconds: 1), () {
        context.goNamed(rSignUp, extra: tutorialData);
      });
      return;
    }
    selectedName = selected;
    isCorrect = selected == correctOption?.name;

    setState(() {
      if (isCorrect) {
        isWaitingForDiscovery = true;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            showFeedback = true;
            isWaitingForDiscovery = false;
            setState(() {});
          }
        });
      }
    });

    submitAnswer(
      entityId: correctOption!.id,
      duration: duration.inMilliseconds / 1000,
      isCorrect: isCorrect,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizNotifierProvider);
    final userProfileAsync = ref.watch(userProfileStreamProvider);

    return quizAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (options) {
        if (options.isEmpty) {
          return const Scaffold(body: Center(child: Text('No data')));
        }

        correctOption ??= options.first;
        shuffledOptions ??= List<PokemonBase>.from(options)..shuffle(Random());

        final profile = userProfileAsync.asData?.value;
        final isDiscovered =
            profile?.discoveredEntities.any((e) => e.id == correctOption?.id) ??
            false;

        if (isWaitingForDiscovery && isDiscovered) {
          isWaitingForDiscovery = false;
          showFeedback = true;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                selectedName != null && !showFeedback
                    ? Colors.black
                    : const Color(0xFFFF4719),
            title:
                selectedName != null && !showFeedback
                    ? null
                    : Image.asset(
                      'assets/images/guess_icon.png',
                      height: 46,
                      fit: BoxFit.fitHeight,
                    ),
          ),
          floatingActionButton:
              widget.isTutorial
                  ? null
                  : selectedName != null && showFeedback
                  ? FloatingActionButton.extended(
                    backgroundColor: isCorrect ? Colors.green : Colors.red,
                    onPressed: reloadQuestion,
                    label:
                        isCorrect
                            ? const Text('Catch It')
                            : const Text('Try Again'),
                    icon: const Icon(Icons.catching_pokemon),
                  )
                  : null,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: const Color(0xFFFF4719),
                    height: 64,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/pokemon_logo.svg',
                        height: 112,
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xFFFF4719),
                    height: 240,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/whos_that_poke.gif',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        CachedNetworkImage(
                          imageUrl: correctOption!.imageUrl,
                          imageBuilder: (context, imageProvider) {
                            startTime ??= DateTime.now();
                            if (selectedName == null) {
                              _player.resume();
                            }
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                  colorFilter:
                                      isDiscovered || showFeedback
                                          ? null
                                          : const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                ),
                              ),
                            );
                          },
                          placeholder:
                              (_, _) => const SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget: (_, _, _) {
                            if (!hasImageError) {
                              hasImageError = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                reloadQuestion();
                              });
                            }
                            return const Icon(Icons.error, size: 48);
                          },
                        ),
                      ],
                    ),
                  ),
                  Gaps.h16,
                  if (widget.isTutorial)
                    Text(
                      "Welcome in PokeQuiz\nIt's your first Catch\n Choose ${correctOption?.name} to go next",
                      textAlign: TextAlign.center,
                    ),

                  if (selectedName == null)
                    ...shuffledOptions!.map(
                      (option) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedName == null
                                    ? null
                                    : option.name == correctOption?.name
                                    ? Colors.green
                                    : option.name == selectedName
                                    ? Colors.red
                                    : null,
                          ),
                          onPressed: () {
                            onOptionSelected(option.name);
                          },
                          child: Text(option.name),
                        ),
                      ),
                    ),
                  if (selectedName != null && showFeedback)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        isCorrect
                            ? 'You caught it!\nIt was ${correctOption!.name}'
                            : 'Incorrect!\nIt was ${correctOption!.name}',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              if (selectedName != null && !showFeedback)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
