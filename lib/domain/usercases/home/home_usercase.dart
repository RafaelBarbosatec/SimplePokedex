import 'dart:async';

import 'package:simple_pokedex/core/util/extensions.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/pokemon_type_repository.dart';
import 'package:simple_pokedex/domain/entities/home_entity.dart';

class HomeUserCase {
  final PokemonRepository _pokemonRepository;
  final PokemonTypeRepository _typeRepository;

  HomeUserCase(this._pokemonRepository, this._typeRepository);

  Future<HomeEntity> fetchHome({
    int page = 0,
    int limit = 20,
    String name,
    String type,
  }) async {
    List<PokemonType> typeList = await _typeRepository.getPokemonTypes();

    List<Pokemon> pokemonList = await _pokemonRepository
        .getPokemonList(page: page, name: name, type: type, limit: limit)
        .then((response) => _mapTypeInList(response, typeList));

    return Future.value(
      HomeEntity(
        pokemonList: pokemonList,
        pokemonTypeList: typeList,
      ),
    );
  }

  List<Pokemon> _mapTypeInList(
    List<Pokemon> pokemonList,
    List<PokemonType> pokemonTypeList,
  ) {
    pokemonList?.forEach((p) {
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
