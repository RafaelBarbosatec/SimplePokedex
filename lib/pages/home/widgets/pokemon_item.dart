import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/widgets/type_item.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';

class PokemonItem extends StatelessWidget {
  final Pokemon pokemon;
  final GestureTapCallback onTap;

  const PokemonItem({Key key, this.pokemon, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16) + EdgeInsets.only(top: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              imageUrl: pokemon.thumbnailImage,
              placeholder: (context, url) => Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'assets/simbol_pokemon.png',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          _buildName(context),
          Expanded(
            child: Container(),
          ),
          _buildTypes(context)
        ],
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '#${pokemon.number}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            pokemon.name,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypes(BuildContext context) {
    if (pokemon.typeObjects == null) {
      return SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pokemon.typeObjects.map<Widget>((type) {
        return TypeItem(
          type: type,
          selected: true,
          size: 30,
        );
      }).toList(),
    );
  }
}
