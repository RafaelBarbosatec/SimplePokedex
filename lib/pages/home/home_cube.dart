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
  final typeSelected = ObservableValue<PokemonType>();
  final pokemonList = ObservableList<Pokemon>(value: []);
  final pokemonTypeList = ObservableList<PokemonType>(value: []);
  final snackBarControl = ObservableValue<CFeedBackControl<String>>(value: CFeedBackControl());

  bool get canLoadMore => pokemonList.length % LIMIT == 0;

  @override
  void ready() {
    loadPokemonList();
    super.ready();
  }

  void didSelectType(PokemonType type) {
    typeSelected.update(type);
    loadPokemonList();
  }

  void didSearchPerName(String name) {
    runDebounce(KEY_DEBOUNCE, () {
      loadPokemonList(pokemonName: name);
    });
  }

  void loadPokemonList({
    bool loadMore = false,
    String pokemonName,
  }) {
    if (progress.value || (loadMore && !canLoadMore)) return;

    int page = 0;
    if (loadMore) page = (pokemonList.length ~/ LIMIT) + 1;

    if (showEmpty.value) showEmpty.update(false);
    if (!progress.value) progress.update(true);

    _pokemonRepository
        .getPokemonList(
          page: page,
          name: pokemonName,
          type: typeSelected?.value?.name,
          limit: LIMIT,
        )
        .asStream()
        .asyncMap(_mapListWithTypes)
        .listen(
          (response) => _onResponse(response, loadMore),
          onError: (error) => snackBarControl.modify((value) => value.copyWith(show: true, data: error.toString())),
          onDone: () => progress.update(false),
        );
  }

  Future<List<Pokemon>> _mapListWithTypes(List<Pokemon> event) async {
    final list = await _loadPokemonTypes();
    pokemonTypeList.update(list);
    return _mapTypeInList(
      pokemonList: event,
      pokemonTypeList: pokemonTypeList.value,
    );
  }

  Future<List<PokemonType>> _loadPokemonTypes() {
    return _pokemonRepository
        .getPokemonTypes()
        .catchError((error) => snackBarControl.modify((value) => value.copyWith(show: true, data: error.toString())));
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
      pokemonList.update(event);
      showEmpty.update(pokemonList.value.isEmpty);
    }
  }
}
