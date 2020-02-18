import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/util/con.dart';

class PokemonRepository {
  final Con _con;

  PokemonRepository(this._con);

  Future<List<Pokemon>> getPokemons() {
    return _con.get('pokemon').then((response) => response['data']
        .map<Pokemon>((item) => Pokemon.fromJson(item))
        .toList());
  }

  Future<List<PokemonType>> getPokemonsTypes() {
    return _con.get('pokemon/types').then((response) => response['data']
        .map<PokemonType>((item) => PokemonType.fromJson(item))
        .toList());
  }
}
