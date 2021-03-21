import 'package:simple_pokedex/core/data/network/network_client.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';

class PokemonRepository {
  final NetworkClient _api;
  PokemonRepository(this._api);

  Future<List<Pokemon>> getPokemonList({
    int page = 0,
    int? limit,
    String? name,
    String? type,
  }) {
    Map<String, dynamic> params = Map();
    params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (type != null) params['type'] = type;

    return _api.get('pokemon', queryParameters: params).then((response) {
      return response.data['data']
          .map<Pokemon>((item) => Pokemon.fromJson(item))
          .toList();
    });
  }
}
