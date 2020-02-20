import 'package:flutter/material.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';
import 'package:simple_pokedex/util/hex_color.dart';

class TypeItem extends StatelessWidget {
  final PokemonType type;
  final bool selected;
  final GestureTapCallback onTap;

  const TypeItem({Key key, this.type, this.selected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: Duration(microseconds: 300),
        opacity: selected ? 1.0 : 0.5,
        child: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                if (selected)
                  BoxShadow(
                      blurRadius: 10,
                      offset: Offset(4.0, 4.0),
                      color: HexColor(type.color))
              ]),
          child: InkWell(onTap: onTap, child: Image.network(type.image)),
        ),
      ),
    );
  }
}
