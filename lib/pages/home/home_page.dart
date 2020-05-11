import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/pages/home/widgets/header.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_empty.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_item.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_type_list.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Bsev<HomeBloc, HomeStreams>(
          builder: (context, communication) {
            return Stack(
              children: <Widget>[
                _buildContent(context, communication),
                _buildProgress(communication.streams)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, BlocCommunication<HomeStreams> communication) {
    return Column(
      children: <Widget>[
        Header(communication: communication),
        SizedBox(
          height: 10,
        ),
        _buildTypes(communication),
        Expanded(
          child: _buildPokemons(communication),
        )
      ],
    );
  }

  Widget _buildTypes(BlocCommunication<HomeStreams> communication) {
    return communication.streams.pokemonsTypes
        .builder<List<PokemonType>>((types) {
      return PokemonTypeList(
        types: types,
        typeSelected: (type) {
          communication.dispatcher(SelectType(type));
        },
      );
    });
  }

  Widget _buildPokemons(BlocCommunication<HomeStreams> communication) {
    return communication.streams.pokemons.builder<List<Pokemon>>((pokemons) {
      return Stack(
        children: <Widget>[
          ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 16),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                if (index == pokemons.length - 3) {
                  communication.dispatcher(LoadPokemons(true));
                }

                return PokemonItem(
                  pokemon: pokemons[index],
                );
              }),
          Container(
            height: 10,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0.0, 5),
                  color: Colors.grey[300])
            ]),
          ),
          _buildEmpty(communication),
        ],
      );
    });
  }

  Widget _buildProgress(HomeStreams streams) {
    return streams.progress.builder((show) {
      return show
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox.shrink();
    });
  }

  Widget _buildEmpty(BlocCommunication<HomeStreams> communication) {
    return communication.streams.showEmpty.builder<bool>((show) {
      return show ? PokemonEmpty() : SizedBox.shrink();
    });
  }
}
