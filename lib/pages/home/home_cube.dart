import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/util/debouncer.dart';
import 'package:simple_pokedex/util/extensions.dart';

class HomeCube extends Cube {
  HomeCube(this._pokemonRepository);
  final PokemonRepository _pokemonRepository;
  final Debouncer _debouncer = Debouncer(Duration(milliseconds: 600));

  final progress = ObservableValue<bool>(initValue: false);
  final showEmpty = ObservableValue<bool>(initValue: false);
  final pokemonList = ObservableValue<List<Pokemon>>(initValue: []);
  final pokemonTypeList = ObservableValue<List<PokemonType>>(initValue: []);

  PokemonType _typeSelected;
  int _page = 0;
  static const int LIMIT = 15;
  String _name;
  bool _canLoadMore = true;

  @override
  void ready() {
    _loadPokemonListAndTypes();
    super.ready();
  }

  void _loadPokemonListAndTypes() async {
    progress.set(true);
    showEmpty.set(false);

    final types = await _pokemonRepository
        .getPokemonTypes()
        .catchError((error) => print(error));

    pokemonTypeList.set(types);
    loadPokemonList(force: true);
  }

  void selectType(PokemonType type) {
    this._typeSelected = type;
    loadPokemonList();
  }

  void loadPokemonList({bool loadMore = false, bool force = false}) async {
    if ((progress.value && !force) || (loadMore && !_canLoadMore)) return;

    loadMore ? _page++ : _page = 0;

    if (showEmpty.value) showEmpty.set(false);
    progress.set(true);

    List<Pokemon> pokeAux = await _pokemonRepository
        .getPokemonList(
          page: _page,
          name: _name,
          type: _typeSelected?.name,
          limit: LIMIT,
        )
        .catchError((error) => onError(error));

    if (pokeAux != null) {
      _canLoadMore = pokeAux.length == LIMIT;

      pokeAux.forEach((p) {
        p.typeObjects = pokemonTypeList.value
            ?.where((t) => p.type.contains(t.name))
            ?.toList();
        p.weaknessObjects = pokemonTypeList.value
            ?.where((t) => p.weakness.contains(t.name.fistLetterUpperCase()))
            ?.toList();
      });

      if (loadMore) {
        pokemonList.value.addAll(pokeAux);
        pokemonList.set(pokemonList.value);
      } else {
        pokemonList.set(pokeAux);
        showEmpty.set(pokemonList.value.isEmpty);
      }
    }
    progress.set(false);
  }

  void searchName(String name) {
    _debouncer.call(() {
      this._name = (name?.isEmpty ?? true) ? null : name;
      loadPokemonList();
    });
  }
}
