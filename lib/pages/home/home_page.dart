import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/detail/detail_page.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/pages/home/widgets/header.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_empty.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_item.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BsevBuilder<HomeBloc, HomeCommunication>(
          builder: (context, communication) {
            return Stack(
              children: <Widget>[
                _buildContent(context, communication),
                _buildProgress(communication),
                _buildEmpty(communication),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeCommunication communication) {
    return Column(
      children: <Widget>[
        Header(communication: communication),
        SizedBox(
          height: 2,
        ),
        _buildPokemonList(communication)
      ],
    );
  }

  Widget _buildPokemonList(HomeCommunication communication) {
    return Expanded(
      child: communication.pokemons.builder<List<Pokemon>>((list) {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            if (index == list.length - 3) {
              communication.dispatcher(LoadPokemons(true));
            }
            final pokemon = list[index];
            return PokemonItem(
              pokemon: pokemon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      pokemon: pokemon,
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildProgress(HomeCommunication streams) {
    return streams.progress.builder<bool>((show) {
      return show
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox.shrink();
    });
  }

  Widget _buildEmpty(HomeCommunication streams) {
    return streams.showEmpty.builder<bool>((show) {
      return show ? PokemonEmpty() : SizedBox.shrink();
    });
  }
}
