import 'package:flutter/material.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/presentation/widgets/pokemon_type_widget.dart';

class PokemonTypeListWidget extends StatelessWidget {
  final List<PokemonType> types;
  final Function(PokemonType) onTypeSelected;
  final PokemonType selected;

  const PokemonTypeListWidget({
    Key key,
    this.types,
    this.onTypeSelected,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        itemCount: types.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PokemonTypeWidget(
            margin: const EdgeInsets.only(right: 12),
            type: types[index],
            selected: types[index] == selected,
            onTap: () {
              if (types[index] == selected) {
                onTypeSelected?.call(null);
              } else {
                onTypeSelected?.call(types[index]);
              }
            },
          );
        },
      ),
    );
  }
}
