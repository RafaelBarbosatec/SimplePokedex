import 'dart:async';

import 'package:simple_pokedex/core/util/extensions.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/pokemon_type_repository.dart';

class HomeUserCase {
  final PokemonRepository _pokemonRepository;
  final PokemonTypeRepository _typeRepository;

  HomeUserCase(this._pokemonRepository, this._typeRepository);

  Future<List<PokemonType>> getPokemonTypes() {
    return _typeRepository.getPokemonTypes();
  }

  Future<List<Pokemon>> getPokemonList({
    int page = 0,
    int limit = 20,
    String name,
    String type,
  }) async {
    return _pokemonRepository
        .getPokemonList(page: page, name: name, type: type, limit: limit)
        .then(_mapPokemonList);
  }

  FutureOr<List<Pokemon>> _mapPokemonList(List<Pokemon> pokemonList) async {
    if (pokemonList != null) {
      final typeList = await getPokemonTypes();
      return _mapTypeInList(
        pokemonList: pokemonList,
        pokemonTypeList: typeList,
      );
    } else {
      return [];
    }
  }

  List<Pokemon> _mapTypeInList({
    List<Pokemon> pokemonList,
    List<PokemonType> pokemonTypeList,
  }) {
    pokemonList.forEach((p) {
      p.typeObjects = pokemonTypeList?.where((t) {
        return p.type.contains(t.name);
      })?.toList();
      p.weaknessObjects = pokemonTypeList?.where((t) {
        return p.weakness.contains(t.name.fistLetterUpperCase());
      })?.toList();
    });
    return pokemonList;
  }
}
