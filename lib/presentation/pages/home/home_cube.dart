import 'dart:async';

import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/domain/usercases/home/home_usercase.dart';

class HomeCube extends Cube {
  static const int LIMIT = 15;
  static const String KEY_DEBOUNCE = 'search';

  HomeCube(this._userCase);

  final HomeUserCase _userCase;

  final progress = false.obsValue;
  final showEmpty = false.obsValue;
  final typeSelected = PokemonType().obsValue;
  final pokemonList = List<Pokemon>().obsValue;
  final pokemonTypeList = List<PokemonType>().obsValue;
  final snackBarControl = CFeedBackControl<String>().obsValue;

  bool get canLoadMore => pokemonList.length % LIMIT == 0;

  @override
  void onReady(Object argument) {
    loadPokemonList();
    super.onReady(argument);
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
  }) async {
    if (progress.value || (loadMore && !canLoadMore)) return;

    int page = 0;
    if (loadMore) page = (pokemonList.length ~/ LIMIT) + 1;

    if (showEmpty.value) showEmpty.update(false);
    if (!progress.value) progress.update(true);

    if (pokemonTypeList.isEmpty) {
      await _loadPokemonTypes();
    }

    _userCase
        .getPokemonList(
          page: page,
          name: pokemonName,
          type: typeSelected?.value?.name,
          limit: LIMIT,
        )
        .then((value) => _onResponse(value, loadMore))
        .catchError(_onError)
        .whenComplete(() => progress.update(false));
  }

  Future<void> _loadPokemonTypes() async {
    try {
      final typeList = await _userCase.getPokemonTypes();
      pokemonTypeList.update(typeList);
      return Future.value();
    } catch (e) {
      return Future.value();
    }
  }

  void _onResponse(List<Pokemon> event, bool loadMore) {
    if (loadMore) {
      pokemonList.addAll(event);
    } else {
      pokemonList.update(event);
      showEmpty.update(pokemonList.value.isEmpty);
    }
  }

  void _onError(error) {
    snackBarControl.modify((value) {
      return value.copyWith(show: true, data: error.toString());
    });
  }
}
