import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/widgets/type_item.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/util/hex_color.dart';

class DetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const DetailPage({Key key, this.pokemon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color colorBg = HexColor(pokemon.typeObjects.first.color);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorBg, colorBg.withOpacity(0.7)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(pokemon.name),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100, left: 15, right: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                          top: 100, left: 15, right: 15, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Text(
                              pokemon.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(child: _buildTypes(context)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            pokemon.description,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildDetail(context, colorBg),
                          SizedBox(
                            height: 30,
                          ),
                          _buildWeakness(context),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 200,
                    child: Hero(
                      tag: pokemon.thumbnailImage,
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
                  ),
                ),
              ],
            )
          ],
        ),
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
          margin: const EdgeInsets.only(left: 6, right: 6),
          type: type,
          selected: true,
          size: 30,
        );
      }).toList(),
    );
  }

  Widget _buildDetail(BuildContext context, Color colorBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildLabelAndName(context, 'Weight', pokemon.weight.toString()),
          Container(
            width: 1,
            color: Colors.white.withOpacity(0.5),
            height: 35,
          ),
          _buildLabelAndName(context, 'Height', pokemon.height.toString()),
          Container(
            width: 1,
            color: Colors.white.withOpacity(0.5),
            height: 35,
          ),
          _buildLabelAndName(
              context, 'Abilities', pokemon.abilities.toString()),
        ],
      ),
    );
  }

  Widget _buildLabelAndName(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWeakness(BuildContext context) {
    print(pokemon.weaknessObjects);
    print(pokemon.weakness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Weakness',
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: pokemon.weaknessObjects.map<Widget>((type) {
            return TypeItem(
              margin: const EdgeInsets.only(left: 6, right: 6),
              type: type,
              selected: true,
              size: 30,
            );
          }).toList(),
        )
      ],
    );
  }
}
