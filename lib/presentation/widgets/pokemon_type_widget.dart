import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/core/util/hex_color.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon_type.dart';

class PokemonTypeWidget extends StatelessWidget {
  final PokemonType type;
  final bool selected;
  final GestureTapCallback onTap;
  final double size;
  final EdgeInsetsGeometry margin;

  const PokemonTypeWidget(
      {Key key,
      this.type,
      this.selected = false,
      this.onTap,
      this.size = 50,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: type.name,
      child: AnimatedOpacity(
        duration: Duration(microseconds: 300),
        opacity: selected ? 1.0 : 0.4,
        child: Center(
          child: Container(
            margin: margin,
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(size * 0.05, size * 0.05),
                    color: HexColor(type.color),
                  )
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: onTap,
              child: CachedNetworkImage(
                imageUrl: type.image,
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.all(4),
                  child: Image.asset('assets/simbol_pokemon.png'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
