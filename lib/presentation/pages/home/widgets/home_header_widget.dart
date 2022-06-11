import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/presentation/pages/home/home_cube.dart';
import 'package:simple_pokedex/presentation/pages/home/view_model/type_control_view_model.dart';
import 'package:simple_pokedex/presentation/pages/home/widgets/pokemon_type_list_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCube? homeCube = Cubes.of<HomeCube>(context);
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
                      ?.copyWith(color: Colors.grey[700]),
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
                  onChanged: (name) => homeCube?.didSearchPerName(name),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search per name',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _buildTypes(homeCube) ?? SizedBox.shrink(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget? _buildTypes(HomeCube? cube) {
    return cube?.typeViewModel.build<TypeControlViewModel>((typeViewModel) {
      return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: typeViewModel.types.isEmpty ? 0 : 1,
        child: PokemonTypeListWidget(
          types: typeViewModel.types,
          selected: typeViewModel.typeSelected,
          onTypeSelected: (type) => cube.didSelectType(type),
        ),
      );
    });
  }
}
