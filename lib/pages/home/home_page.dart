import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Bsev<HomeBloc, HomeStreams>(
      builder: (context, communication) {
        return Stack(
          children: <Widget>[
            _buildContent(communication),
            _buildProgress(communication.streams)
          ],
        );
      },
    );
  }

  Widget _buildContent(BlocCommunication<HomeStreams> communication) {
    return Column(
      children: <Widget>[
        _buildTypes(communication.streams),
        Expanded(
          child: _buildPokemons(communication.streams),
        )
      ],
    );
  }

  Widget _buildTypes(HomeStreams streams) {
    return streams.pokemonsTypes.builder<List<PokemonType>>((types) {
      return SizedBox(
        height: 70,
        child: ListView.builder(
            itemCount: types.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  child: Image.network(types[index].image));
            }),
      );
    });
  }

  Widget _buildPokemons(HomeStreams streams) {
    return streams.pokemons.builder<List<Pokemon>>((pokemons) {
      return ListView.builder(
          itemCount: pokemons.length,
          itemBuilder: (context, index) {
            return Container(
                height: 150,
                child: Image.network(pokemons[index].thumbnailImage));
          });
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
}
