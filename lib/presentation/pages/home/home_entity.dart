import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';

class HomeEntity {
  final List<Pokemon> pokemonList;
  final List<PokemonType> pokemonTypeList;

  HomeEntity({required this.pokemonList, required this.pokemonTypeList});
}
