import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/util/con.dart';

class PokemonRepository {
  final Con _con;

  PokemonRepository(this._con);

  Future<List<Pokemon>> getPokemons(
      {int page = 0, int limit, String name, String type}) {
    Map<String, dynamic> params = Map();
    params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (name != null) params['name'] = name;
    if (type != null) params['type'] = type;

    return _con.get('pokemon', queryParameters: params).then((response) =>
        response['data']
            .map<Pokemon>((item) => Pokemon.fromJson(item))
            .toList());
  }

  Future<List<PokemonType>> getPokemonsTypes() {
    return _con.get('pokemon/types').then((response) => response['data']
        .map<PokemonType>((item) => PokemonType.fromJson(item))
        .toList());
  }
}
