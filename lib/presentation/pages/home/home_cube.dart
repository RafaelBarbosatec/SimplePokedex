import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/domain/entities/home/home_entity.dart';
import 'package:simple_pokedex/domain/usercases/home/home_usercase.dart';
import 'package:simple_pokedex/presentation/pages/home/view_model/type_control_view_model.dart';

class HomeCube extends Cube {
  static const int LIMIT = 15;
  static const String KEY_DEBOUNCE = 'search';

  HomeCube(this._userCase);

  final HomeUserCase _userCase;

  final progress = false.obsValue;
  final showEmpty = false.obsValue;
  final typeViewModel = TypeControlViewModel(types: []).obsValue;
  final pokemonList = <Pokemon>[].obsValue;
  final snackBarControl = CFeedBackControl<String>().obsValue;

  bool get canLoadMore => pokemonList.length % LIMIT == 0;

  @override
  void onReady(Object? argument) {
    loadPokemonList();
    super.onReady(argument);
  }

  void didSelectType(PokemonType? type) {
    typeViewModel.modify((value) => value.updateSelected(selected: type));
    loadPokemonList(pokemonType: type);
  }

  void didSearchPerName(String name) {
    runDebounce(KEY_DEBOUNCE, () {
      loadPokemonList(pokemonName: name);
    });
  }

  void loadPokemonList({
    bool loadMore = false,
    String? pokemonName,
    PokemonType? pokemonType,
  }) async {
    if (progress.value || (loadMore && !canLoadMore)) return;

    int page = 0;
    if (loadMore) page = (pokemonList.length ~/ LIMIT) + 1;

    if (showEmpty.value) showEmpty.update(false);
    if (!progress.value) progress.update(true);
    if (!loadMore) pokemonList.clear();

    _userCase
        .fetchHome(
          page: page,
          name: pokemonName,
          type: (pokemonType ?? typeViewModel.value.typeSelected)?.name,
          limit: LIMIT,
        )
        .then((value) => _onResponse(value, loadMore))
        .catchError(_onError)
        .whenComplete(() => progress.update(false));
  }

  void _onResponse(HomeEntity event, bool loadMore) {
    typeViewModel.modify(
      (value) => value.updateList(list: event.pokemonTypeList),
    );
    if (loadMore) {
      pokemonList.addAll(event.pokemonList);
    } else {
      pokemonList.update(event.pokemonList);
      showEmpty.update(pokemonList.value.isEmpty);
    }
  }

  void _onError(error) {
    snackBarControl.modify((value) {
      return value.copyWith(show: true, data: error.toString());
    });
  }
}
