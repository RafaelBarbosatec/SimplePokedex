import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/widgets/type_item.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class PokemonTypeList extends StatefulWidget {
  final List<PokemonType> types;
  final Function(PokemonType) typeSelected;

  const PokemonTypeList({Key key, this.types, this.typeSelected})
      : super(key: key);
  @override
  _PokemonTypeListState createState() => _PokemonTypeListState();
}

class _PokemonTypeListState extends State<PokemonTypeList> {
  int indexSelected = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
          padding: EdgeInsets.only(left: 16),
          itemCount: widget.types.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TypeItem(
              type: widget.types[index],
              selected: index == indexSelected,
              onTap: () {
                if (widget.typeSelected != null)
                  widget.typeSelected(widget.types[index]);
                setState(() {
                  indexSelected = index;
                });
              },
            );
          }),
    );
  }
}
