import 'package:cubes/cubes.dart';
import 'package:dio/dio.dart';
import 'package:simple_pokedex/data/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/domain/usercases/home_usercase.dart';
import 'package:simple_pokedex/presentation/pages/home/home_cube.dart';

class DI {
  static inject() {
    _injectUtils();
    _injectCubes();
  }

  static void _injectCubes() {
    Cubes.registerDependency((i) => HomeCube(i.getDependency()));
    Cubes.registerDependency((i) => HomeUserCase(i.getDependency()));
  }

  static void _injectUtils() {
    Cubes.registerDependency(
      (i) => Dio(BaseOptions(baseUrl: 'http://104.131.18.84/')),
      isSingleton: true,
    );
    Cubes.registerDependency(
      (i) => PokemonRepository(i.getDependency()),
      isSingleton: true,
    );
  }
}
