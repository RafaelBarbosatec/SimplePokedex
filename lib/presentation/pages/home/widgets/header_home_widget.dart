import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/model/pokemon_type.dart';
import 'package:simple_pokedex/presentation/pages/home/home_cube.dart';
import 'package:simple_pokedex/presentation/pages/home/widgets/pokemon_type_list_widget.dart';

class HeaderHomeWidget extends StatefulWidget {
  const HeaderHomeWidget({Key key}) : super(key: key);

  @override
  _HeaderHomeWidgetState createState() => _HeaderHomeWidgetState();
}

class _HeaderHomeWidgetState extends State<HeaderHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(),
      elevation: 4,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 20),
                child: Text(
                  'SimplePokedex',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 20),
                child: Image.asset(
                  'assets/pokebola_img.png',
                  height: 30,
                  width: 30,
                ),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (name) =>
                      Cubes.of<HomeCube>(context).didSearchPerName(name),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: Cubes.getString('search')),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _buildTypes(Cubes.of(context)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTypes(HomeCube cube) {
    return cube.typeSelected.build<PokemonType>((selected) {
      return cube.pokemonTypeList.build<List<PokemonType>>(
        (types) {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: types.isEmpty ? 0 : 1,
            child: PokemonTypeListWidget(
              types: types,
              selected: selected,
              onTypeSelected: (type) => cube.didSelectType(type),
            ),
          );
        },
      );
    });
  }
}
