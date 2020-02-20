import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_item.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_type_list.dart';
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
        _buildTypes(communication),
        Expanded(
          child: _buildPokemons(communication.streams),
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
          print(type);
        },
      );
    });
  }

  Widget _buildPokemons(HomeStreams streams) {
    return streams.pokemons.builder<List<Pokemon>>((pokemons) {
      return ListView.builder(
          itemCount: pokemons.length,
          itemBuilder: (context, index) {
            return PokemonItem(
              pokemon: pokemons[index],
            );
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
