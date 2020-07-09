import 'package:bsev/bsev.dart';
import 'package:simple_pokedex/pages/home/bloc/home_communication.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/util/extensions.dart';

export 'package:simple_pokedex/pages/home/bloc/home_communication.dart';

class HomeBloc extends Bloc<HomeCommunication> {
  final PokemonRepository _pokemonRepository;

  List<Pokemon> pokemons = List();
  List<PokemonType> pokemonTypes = List();
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
      loadPokemonList(loadMore: event.isMore);
    }
  }

  @override
  void init() {
    communication.queryDebounce.subject
        .debounceTime(Duration(milliseconds: 600))
        .listen(_mapSearchName);
    _loadPokemonListAndTypes();
  }

  void _loadPokemonListAndTypes() async {
    communication.progress.set(true);
    communication.showEmpty.set(false);

    pokemons = await _pokemonRepository
        .getPokemonList()
        .catchError((error) => print(error));
    pokemonTypes = await _pokemonRepository
        .getPokemonTypes()
        .catchError((error) => print(error));
    pokemons?.forEach((p) {
      p.typeObjects =
          pokemonTypes?.where((t) => p.type.contains(t.name))?.toList();
      p.weaknessObjects = pokemonTypes
          ?.where((t) => p.weakness.contains(t.name.fistLetterUpperCase()))
          ?.toList();
    });

    communication.pokemons.set(pokemons);
    communication.pokemonsTypes.set(pokemonTypes);
    communication.showEmpty.set(pokemons.isEmpty);
    communication.progress.set(false);
  }

  void _mapSelectType(PokemonType type) {
    this.type = type?.name;
    loadPokemonList();
  }

  void loadPokemonList({bool loadMore = false}) async {
    if (communication.progress.value || (loadMore && !canLoadMore)) return;

    loadMore ? page++ : page = 0;

    communication.showEmpty.set(false);
    communication.progress.set(true);

    List<Pokemon> pokeAux = await _pokemonRepository
        .getPokemonList(page: page, name: name, type: type, limit: LIMIT)
        .catchError((error) => print(error));

    if (pokeAux != null) {
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
    }

    communication.pokemons.set(pokemons);
    communication.progress.set(false);
  }

  void _mapSearchName(String name) {
    this.name = (name?.isEmpty ?? true) ? null : name;
    loadPokemonList();
  }
}
