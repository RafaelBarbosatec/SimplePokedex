import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';

class TypeControlViewModel {
  final PokemonType? typeSelected;

  final List<PokemonType> types;
  TypeControlViewModel({this.typeSelected, required this.types});

  TypeControlViewModel updateList({
    List<PokemonType>? list,
  }) {
    return new TypeControlViewModel(
      typeSelected: this.typeSelected,
      types: list ?? this.types,
    );
  }

  TypeControlViewModel updateSelected({
    PokemonType? selected,
  }) {
    return new TypeControlViewModel(
      typeSelected: selected,
      types: this.types,
    );
  }
}
