import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_type_list.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class Header extends StatelessWidget {
  final HomeCommunication communication;

  const Header({Key key, this.communication}) : super(key: key);
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
                      .title
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
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (name) {
                    communication.dispatcher(SearchName(name));
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search per name'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _buildTypes(communication),
        ],
      ),
    );
  }

  Widget _buildTypes(HomeCommunication communication) {
    return communication.pokemonsTypes.builder<List<PokemonType>>((types) {
      return PokemonTypeList(
        types: types,
        typeSelected: (type) {
          communication.dispatcher(SelectType(type));
        },
      );
    });
  }
}
