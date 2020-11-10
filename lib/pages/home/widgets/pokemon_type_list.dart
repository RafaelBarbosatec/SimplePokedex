import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/widgets/type_item.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class PokemonTypeList extends StatelessWidget {
  final List<PokemonType> types;
  final Function(PokemonType) onTypeSelected;
  final PokemonType selected;

  const PokemonTypeList({Key key, this.types, this.onTypeSelected, this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        itemCount: types.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return TypeItem(
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
