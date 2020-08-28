import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/util/extensions.dart';

class HomeCube extends Cube {
  static const int LIMIT = 15;

  HomeCube(this._pokemonRepository);
  final PokemonRepository _pokemonRepository;

  final progress = ObservableValue<bool>(value: false);
  final showEmpty = ObservableValue<bool>(value: false);
  final pokemonList = ObservableList<Pokemon>(value: []);
  final pokemonTypeList = ObservableList<PokemonType>(value: []);

  PokemonType _typeSelected;
  int _page = 0;
  String _name;
  bool _canLoadMore = true;

  @override
  void ready() {
    _loadPokemonListAndTypes();
    super.ready();
  }

  void _loadPokemonListAndTypes() {
    if (showEmpty.value) showEmpty.value = false;
    progress.value = true;

    _pokemonRepository
        .getPokemonTypes()
        .then((types) => pokemonTypeList.value = types)
        .catchError((error) => onError(error.toString()));

    loadPokemonList(force: true);
  }

  void selectType(PokemonType type) {
    this._typeSelected = type;
    loadPokemonList();
  }

  void loadPokemonList({bool loadMore = false, bool force = false}) async {
    if ((progress.value && !force) || (loadMore && !_canLoadMore)) return;

    loadMore ? _page++ : _page = 0;

    if (showEmpty.value) showEmpty.value = false;
    if (!progress.value) progress.value = true;

    _pokemonRepository
        .getPokemonList(
          page: _page,
          name: _name,
          type: _typeSelected?.name,
          limit: LIMIT,
        )
        .then((response) {
          _canLoadMore = response.length == LIMIT;
          _setTypeInList(response);
          if (loadMore) {
            pokemonList.addAll(response);
          } else {
            pokemonList.value = response;
            showEmpty.value = pokemonList.value.isEmpty;
          }
        })
        .catchError((error) => onError(error))
        .whenComplete(() {
          progress.value = false;
        });
  }

  void searchName(String name) {
    runDebounce('search', () {
      this._name = (name?.isEmpty ?? true) ? null : name;
      loadPokemonList();
    });
  }

  void _setTypeInList(List<Pokemon> response) {
    response.forEach((p) {
      p.typeObjects = pokemonTypeList.value
          ?.where((t) => p.type.contains(t.name))
          ?.toList();
      p.weaknessObjects = pokemonTypeList.value
          ?.where((t) => p.weakness.contains(t.name.fistLetterUpperCase()))
          ?.toList();
    });
  }
}
