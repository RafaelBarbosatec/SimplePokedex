import 'package:dio/dio.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class PokemonRepository {
  final Dio _api;

  PokemonRepository(this._api);

  Future<List<Pokemon>> getPokemonList({
    int page = 0,
    int limit,
    String name,
    String type,
  }) {
    Map<String, dynamic> params = Map();
    params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (type != null) params['type'] = type;

    return _api
        .get('pokemon', queryParameters: params)
        .then((response) => response.data['data'].map<Pokemon>((item) => Pokemon.fromJson(item)).toList());
  }

  Future<List<PokemonType>> getPokemonTypes() {
    return _api
        .get('pokemon/types')
        .then((response) => response.data['data'].map<PokemonType>((item) => PokemonType.fromJson(item)).toList());
  }
}
