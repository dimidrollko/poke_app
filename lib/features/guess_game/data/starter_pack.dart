enum StarterPokemon {
  bulbasaur(1),
  charmander(4),
  pikachu(25),
  psyduck(54);

  final int id;

  const StarterPokemon(this.id);

  static StarterPokemon any() {
    return (StarterPokemon.values.toList()..shuffle()).first;
  }
}
