import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/util/hex_color.dart';

class DetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const DetailPage({Key key, this.pokemon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color colorbg = HexColor(pokemon.typeObjects.first.color);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorbg, colorbg.withOpacity(0.5)],
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
          children: <Widget>[
            Stack(
              children: <Widget>[
                Card(
                  elevation: 5,
                  margin: EdgeInsets.only(top: 100, left: 15, right: 15),
                  color: Colors.white,
                  child: Container(
                    height: 400,
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
}
