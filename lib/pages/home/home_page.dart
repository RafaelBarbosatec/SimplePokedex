import 'package:bsev/bsev.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_item.dart';
import 'package:simple_pokedex/pages/home/widgets/pokemon_type_list.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
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
    );
  }

  Widget _buildContent(
      BuildContext context, BlocCommunication<HomeStreams> communication) {
    return Column(
      children: <Widget>[
        ..._buildHeader(context, communication),
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
          )
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

  List<Widget> _buildHeader(
      BuildContext context, BlocCommunication<HomeStreams> communication) {
    return [
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
              color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
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
        height: 10,
      ),
    ];
  }
}
