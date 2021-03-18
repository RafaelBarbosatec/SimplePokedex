import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/data/repositories/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/presentation/pages/detail/detail_page.dart';
import 'package:simple_pokedex/presentation/pages/home/home_cube.dart';
import 'package:simple_pokedex/presentation/pages/home/widgets/header_home_widget.dart';
import 'package:simple_pokedex/presentation/pages/home/widgets/not_found_widget.dart';
import 'package:simple_pokedex/presentation/pages/home/widgets/pokemon_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CubeBuilder<HomeCube>(
      builder: (context, HomeCube cube) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: CFeedBackManager(
            snackBarControllers: [
              CSnackBarController<String>(
                observable: cube.snackBarControl,
                builder: (value, context) => SnackBar(content: Text(value)),
              ),
            ],
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  _buildContent(context, cube),
                  _buildProgress(cube),
                  _buildEmpty(cube),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeCube cube) {
    return Column(
      children: <Widget>[
        HeaderHomeWidget(),
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
              return PokemonWidget(
                pokemon: pokemon,
                onTap: () => context.goTo(DetailPage(pokemon: pokemon)),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildProgress(HomeCube cube) {
    return cube.progress.build<bool>(
      (show) => genericCondition<Widget>(
        condition: show,
        match: Center(child: CircularProgressIndicator()),
      ),
      animate: true,
    );
  }

  Widget _buildEmpty(HomeCube cube) {
    return cube.showEmpty.build<bool>(
      (show) => genericCondition(condition: show, match: NotFoundWidget()),
      animate: true,
    );
  }
}
