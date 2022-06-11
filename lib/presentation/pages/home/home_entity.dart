import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';

class HomeEntity {
  final List<Pokemon> pokemonList;
  final List<PokemonType> pokemonTypeList;

  HomeEntity({required this.pokemonList, required this.pokemonTypeList});
}

class TypeControlEntity {
  final PokemonType? typeSelected;
  final List<PokemonType> types;

  TypeControlEntity({this.typeSelected, required this.types});

  TypeControlEntity updateList({
    List<PokemonType>? list,
  }) {
    return new TypeControlEntity(
      typeSelected: this.typeSelected,
      types: list ?? this.types,
    );
  }

  TypeControlEntity updateSelected({
    PokemonType? selected,
  }) {
    return new TypeControlEntity(
      typeSelected: selected,
      types: this.types,
    );
  }
}
