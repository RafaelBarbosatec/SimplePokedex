import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/core/util/extensions.dart';
import 'package:simple_pokedex/core/util/hex_color.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/presentation/widgets/pokemon_type_widget.dart';

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
          colors: [
            colorBg,
            colorBg.withOpacity(0.7),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: pokemon.name.title(context, color: Colors.white),
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
                            child: pokemon.name.title(context),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(child: _buildTypes(context)),
                          SizedBox(
                            height: 20,
                          ),
                          pokemon.description
                              .body(context, textAlign: TextAlign.center),
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
        return PokemonTypeWidget(
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
          _buildLabelAndName(
              context, Cubes.getString('weight'), pokemon.weight.toString()),
          Container(
            width: 1,
            color: Colors.white.withOpacity(0.5),
            height: 35,
          ),
          _buildLabelAndName(
              context, Cubes.getString('height'), pokemon.height.toString()),
          Container(
            width: 1,
            color: Colors.white.withOpacity(0.5),
            height: 35,
          ),
          _buildLabelAndName(context, Cubes.getString('abilities'),
              pokemon.abilities.toString()),
        ],
      ),
    );
  }

  Widget _buildLabelAndName(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        label.title(context, fontSize: 16, color: Colors.white),
        SizedBox(
          height: 4,
        ),
        value.body(context, fontSize: 14, color: Colors.white),
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
        Cubes.getString('weakness').title(context, fontSize: 16),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: pokemon.weaknessObjects.map<Widget>((type) {
            return PokemonTypeWidget(
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
