import 'package:simple_pokedex/core/util/extensions.dart';
import 'package:simple_pokedex/data/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/data/repository/pokemon/pokemon_repository.dart';

class HomeUserCase {
  final PokemonRepository _repository;

  HomeUserCase(this._repository);

  Future<List<PokemonType>> getPokemonTypes() {
    return _repository.getPokemonTypes();
  }

  Future<List<Pokemon>> getPokemonList({
    int page = 0,
    int limit = 20,
    String name,
    String type,
  }) async {
    final pokemonList = await _repository.getPokemonList(
      page: page,
      name: name,
      type: type,
      limit: limit,
    );

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
