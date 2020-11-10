import 'dart:async';

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
    loadPokemonList();
    super.ready();
  }

  void didSelectType(PokemonType type) {
    typeSelected.value = type;
    loadPokemonList();
  }

  void didSearchPerName(String name) {
    runDebounce(KEY_DEBOUNCE, () {
      loadPokemonList(pokemonName: name);
    });
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
        .asStream()
        .asyncMap(_mapList)
        .listen(
          (response) => _onResponse(response, loadMore),
          onError: (error) => onAction(CubeErrorAction(text: error.toString())),
          onDone: () => progress.value = false,
        );
  }

  Future<List<PokemonType>> _loadPokemonTypes() {
    return _pokemonRepository
        .getPokemonTypes()
        .catchError((error) => onAction(CubeErrorAction(text: error.toString())));
  }

  Future<List<Pokemon>> _mapList(List<Pokemon> event) async {
    pokemonTypeList.value = await _loadPokemonTypes();
    return _mapTypeInList(
      pokemonList: event,
      pokemonTypeList: pokemonTypeList.value,
    );
  }

  List<Pokemon> _mapTypeInList({List<Pokemon> pokemonList, List<PokemonType> pokemonTypeList}) {
    pokemonList.forEach((p) {
      p.typeObjects = pokemonTypeList?.where((t) => p.type.contains(t.name))?.toList();
      p.weaknessObjects = pokemonTypeList?.where((t) {
        return p.weakness.contains(t.name.fistLetterUpperCase());
      })?.toList();
    });
    return pokemonList;
  }

  void _onResponse(List<Pokemon> event, bool loadMore) {
    if (loadMore) {
      pokemonList.addAll(event);
    } else {
      pokemonList.value = event;
      showEmpty.value = pokemonList.value.isEmpty;
    }
  }
}
