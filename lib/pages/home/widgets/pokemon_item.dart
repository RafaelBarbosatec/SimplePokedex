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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Image.network(
            pokemon.thumbnailImage,
            height: 100,
            width: 100,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '#${pokemon.number}',
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          pokemon.name,
          style: TextStyle(fontSize: 20),
        ),
      ],
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
