import 'package:bsev/bloc_base.dart';
import 'package:bsev/bsev.dart';
import 'package:bsev/events_base.dart';
import 'package:simple_pokedex/pages/home/bloc/home_communication.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';

export 'package:simple_pokedex/pages/home/bloc/home_communication.dart';

class HomeBloc extends BlocBase<HomeCommunication> {
  final PokemonRepository _pokemonRepository;

  List<Pokemon> pokemons;
  List<PokemonType> pokemonTypes;
  int page = 0;
  static const int LIMIT = 15;
  String name;
  String type;

  bool canLoadMore = true;

  HomeBloc(this._pokemonRepository);

  @override
  void eventReceiver(EventsBase event) {
    if (event is SelectType) {
      _mapSelectType(event.type);
    }

    if (event is SearchName) {
      communication.queryDebounce.set(event.name);
    }

    if (event is LoadPokemons) {
      loadPokemons(loadMore: event.isMore);
    }
  }

  @override
  void initView() {
    communication.queryDebounce.subject
        .debounceTime(Duration(milliseconds: 600))
        .listen(_mapSearchName);
    _loadPokemonsAndTypes();
  }

  void _loadPokemonsAndTypes() async {
    communication.progress.set(true);
    pokemons = await _pokemonRepository
        .getPokemonList()
        .catchError((error) => print(error));
    pokemonTypes = await _pokemonRepository
        .getPokemonTypes()
        .catchError((error) => print(error));
    pokemons.forEach((p) {
      p.typeObjects =
          pokemonTypes.where((t) => p.type.contains(t.name)).toList();
    });
    communication.pokemons.set(pokemons);
    communication.pokemonsTypes.set(pokemonTypes);
    communication.progress.set(false);
  }

  void _mapSelectType(PokemonType type) {
    this.type = type != null ? type.name : null;
    loadPokemons();
  }

  void loadPokemons({bool loadMore = false}) async {
    if (communication.progress.value) return;

    if (loadMore && !canLoadMore) return;

    loadMore ? page++ : page = 0;

    communication.showEmpty.set(false);
    communication.progress.set(true);
    List<Pokemon> pokeAux = await _pokemonRepository
        .getPokemonList(page: page, name: name, type: type, limit: LIMIT)
        .catchError((error) => print(error));

    canLoadMore = pokeAux.length == LIMIT;

    if (loadMore) {
      pokemons.addAll(pokeAux);
    } else {
      pokemons = pokeAux;
      communication.showEmpty.set(pokemons.isEmpty);
    }

    pokemons.forEach((p) {
      p.typeObjects =
          pokemonTypes.where((t) => p.type.contains(t.name)).toList();
    });

    communication.pokemons.set(pokemons);
    communication.progress.set(false);
  }

  void _mapSearchName(String name) {
    this.name = name.isEmpty ? null : name;
    loadPokemons();
  }
}
