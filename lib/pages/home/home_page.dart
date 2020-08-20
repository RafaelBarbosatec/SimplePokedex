import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/detail/detail_page.dart';
import 'package:simple_pokedex/pages/home/home_cube.dart';
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
        child: CubeBuilder<HomeCube>(
          onError: (cube, text) {
            print(text);
          },
          builder: (context, cube) {
            return Stack(
              children: <Widget>[
                _buildContent(context, cube),
                _buildProgress(cube),
                _buildEmpty(cube),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeCube cube) {
    return Column(
      children: <Widget>[
        Header(cube: cube),
        SizedBox(
          height: 2,
        ),
        _buildPokemonList(cube)
      ],
    );
  }

  Widget _buildPokemonList(HomeCube cube) {
    return Expanded(
      child: cube.pokemonList.build<List<Pokemon>>((list) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: list.isEmpty ? 0 : 1,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              if (index == list.length - 3) {
                cube.loadPokemonList(loadMore: true);
              }
              final pokemon = list[index];
              return PokemonItem(
                pokemon: pokemon,
                onTap: () {
                  context.goTo(DetailPage(pokemon: pokemon));
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildProgress(HomeCube cube) {
    return cube.progress.build<bool>((show) {
      return show
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox.shrink();
    });
  }

  Widget _buildEmpty(HomeCube cube) {
    return cube.showEmpty.build<bool>((show) {
      return show ? PokemonEmpty() : SizedBox.shrink();
    });
  }
}
