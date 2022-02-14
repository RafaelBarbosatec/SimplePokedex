import 'package:cubes/cubes.dart';
import 'package:simple_pokedex/core/data/network/dio_network_client.dart';
import 'package:simple_pokedex/core/data/network/network_client.dart';
import 'package:simple_pokedex/data/repositories/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/data/repositories/pokemon_type/pokemon_type_repository.dart';
import 'package:simple_pokedex/domain/usercases/home/home_usercase.dart';
import 'package:simple_pokedex/presentation/pages/home/home_cube.dart';

class DI {
  static inject() {
    _injectUtils();
    _injectCubes();
  }

  static void _injectCubes() {
    Cubes.registerDependency((i) => HomeCube(i.getDependency()));
    Cubes.registerDependency(
      (i) => HomeUserCase(
        i.getDependency(),
        i.getDependency(),
      ),
    );
  }

  static void _injectUtils() {
    Cubes.registerDependency<NetworkClient>(
      (i) => DioNetworkProvider(baseUrl: 'http://104.131.18.84/'),
      type: DependencyRegisterType.lazySingleton,
    );
    Cubes.registerDependency(
      (i) => PokemonRepository(i.getDependency()),
      type: DependencyRegisterType.lazySingleton,
    );
    Cubes.registerDependency(
      (i) => PokemonTypeRepository(i.getDependency()),
      type: DependencyRegisterType.lazySingleton,
    );
  }
}
