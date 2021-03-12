import 'package:simple_pokedex/core/data/network/network_client.dart';

import 'model/pokemon_type.dart';

class PokemonTypeRepository {
  final NetworkClient _api;

  List<PokemonType> cacheTypes;
  PokemonTypeRepository(this._api);

  Future<List<PokemonType>> getPokemonTypes() {
    if (cacheTypes != null) return Future.value(cacheTypes);
    return _api.get('pokemon/types').then((response) {
      cacheTypes = response.data['data']
          .map<PokemonType>((item) => PokemonType.fromJson(item))
          .toList();
      return cacheTypes;
    });
  }
}
