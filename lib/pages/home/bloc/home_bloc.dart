import 'package:bsev/bloc_base.dart';
import 'package:bsev/events_base.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/pages/home/bloc/home_streams.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';

export 'package:simple_pokedex/pages/home/bloc/home_streams.dart';

class HomeBloc extends BlocBase<HomeStreams> {
  final PokemonRepository _pokemonRepository;

  List<Pokemon> pokemons;

  HomeBloc(this._pokemonRepository);

  @override
  void eventReceiver(EventsBase event) {
    if (event is SelectType) {
      _mapSelectType(event.type);
    }
  }

  @override
  void initView() {
    _loadPokemons();
  }

  void _loadPokemons() async {
    streams.progress.set(true);
    pokemons = await _pokemonRepository
        .getPokemons()
        .catchError((error) => print(error));
    List<PokemonType> pokemonTypes = await _pokemonRepository
        .getPokemonsTypes()
        .catchError((error) => print(error));
    pokemons.forEach((p) {
      p.typeObjects =
          pokemonTypes.where((t) => p.type.contains(t.name)).toList();
    });
    streams.pokemons.set(pokemons);
    streams.pokemonsTypes.set(pokemonTypes);
    streams.progress.set(false);
  }

  void _mapSelectType(PokemonType type) {
    if (type == null) {
      streams.pokemons.set(pokemons);
    } else {
      streams.pokemons
          .set(pokemons.where((p) => p.type.contains(type.name)).toList());
    }
  }
}
