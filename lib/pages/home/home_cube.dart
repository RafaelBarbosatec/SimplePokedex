import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/util/extensions.dart';

class HomeCube extends Cube {
  static const int LIMIT = 15;
  static const String KEY_DEBOUNCE = 'search';

  HomeCube(this._pokemonRepository);

  final PokemonRepository _pokemonRepository;

  final progress = ObservableValue<bool>(value: false);
  final showEmpty = ObservableValue<bool>(value: false);
  final pokemonList = ObservableList<Pokemon>(value: []);
  final pokemonTypeList = ObservableList<PokemonType>(value: []);
  final typeSelected = ObservableValue<PokemonType>();

  bool get canLoadMore => pokemonList.length % LIMIT == 0;

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
        .catchError((error) => onAction(CubeErrorAction(text: error.toString())));

    loadPokemonList(force: true);
  }

  void selectType(PokemonType type) {
    typeSelected.value = type;
    loadPokemonList();
  }

  void loadPokemonList({
    bool loadMore = false,
    bool force = false,
    String pokemonName,
  }) {
    if ((progress.value && !force) || (loadMore && !canLoadMore)) return;

    int page = 0;
    if (loadMore) page = (pokemonList.length ~/ LIMIT) + 1;

    if (showEmpty.value) showEmpty.value = false;
    if (!progress.value) progress.value = true;

    _pokemonRepository
        .getPokemonList(
          page: page,
          name: pokemonName,
          type: typeSelected?.value?.name,
          limit: LIMIT,
        )
        .then((response) {
          _setTypeInList(response);
          if (loadMore) {
            pokemonList.addAll(response);
          } else {
            pokemonList.value = response;
            showEmpty.value = pokemonList.value.isEmpty;
          }
        })
        .catchError((error) => onAction(CubeErrorAction(text: error.toString())))
        .whenComplete(() => progress.value = false);
  }

  void searchName(String name) {
    runDebounce(KEY_DEBOUNCE, () {
      loadPokemonList(pokemonName: name);
    });
  }

  void _setTypeInList(List<Pokemon> response) {
    response.forEach((p) {
      p.typeObjects = pokemonTypeList.value?.where((t) => p.type.contains(t.name))?.toList();
      p.weaknessObjects = pokemonTypeList.value?.where((t) {
        return p.weakness.contains(t.name.fistLetterUpperCase());
      })?.toList();
    });
  }
}
