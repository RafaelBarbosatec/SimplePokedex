import 'package:cubes/cubes.dart';
import 'package:dio/dio.dart';
import 'package:simple_pokedex/pages/home/home_cube.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';

void injectDependencies() {
  injectUtils();
  injectCubes();
}

void injectCubes() {
  Cubes.registerDependency((i) => HomeCube(i.getDependency()));
}

void injectUtils() {
  Cubes.registerDependency(
    (i) => Dio(BaseOptions(baseUrl: 'http://104.131.18.84/')),
    isSingleton: true,
  );
  Cubes.registerDependency(
    (i) => PokemonRepository(i.getDependency()),
    isSingleton: true,
  );
}
