import 'package:bsev/bloc_base.dart';
import 'package:bsev/bsev.dart';
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
  List<PokemonType> pokemonTypes;
  int page = 0;
  static const int LIMIT = 15;
  String name;
  String type;

  bool canLoadMore = true;
  final _queryDebounce = BehaviorSubject<String>();

  HomeBloc(this._pokemonRepository) {
    _queryDebounce
        .debounceTime(Duration(milliseconds: 600))
        .listen(_mapSearchName);
  }

  @override
  void eventReceiver(EventsBase event) {
    if (event is SelectType) {
      _mapSelectType(event.type);
    }

    if (event is SearchName) {
      _queryDebounce.add(event.name);
    }

    if (event is LoadPokemons) {
      loadPokemons(loadMore: event.isMore);
    }
  }

  @override
  void initView() {
    _loadPokemonsAndTypes();
  }

  void _loadPokemonsAndTypes() async {
    streams.progress.set(true);
    pokemons = await _pokemonRepository
        .getPokemons()
        .catchError((error) => print(error));
    pokemonTypes = await _pokemonRepository
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
    this.type = type != null ? type.name : null;
    loadPokemons();
  }

  void loadPokemons({bool loadMore = false}) async {
    if (streams.progress.value) return;

    if (loadMore && !canLoadMore) return;

    loadMore ? page++ : page = 0;

    streams.showEmpty.set(false);
    streams.progress.set(true);
    List<Pokemon> pokeAux = await _pokemonRepository
        .getPokemons(page: page, name: name, type: type, limit: LIMIT)
        .catchError((error) => print(error));

    canLoadMore = pokeAux.length == LIMIT;

    if (loadMore) {
      pokemons.addAll(pokeAux);
    } else {
      pokemons = pokeAux;
      streams.showEmpty.set(pokemons.isEmpty);
    }

    pokemons.forEach((p) {
      p.typeObjects =
          pokemonTypes.where((t) => p.type.contains(t.name)).toList();
    });

    streams.pokemons.set(pokemons);
    streams.progress.set(false);
  }

  void _mapSearchName(String name) {
    this.name = name.isEmpty ? null : name;
    loadPokemons();
  }

  @override
  void dispose() {
    _queryDebounce.close();
    super.dispose();
  }
}
