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
    Cubes.registerFactory((i) => HomeCube(i.get()));
    Cubes.registerFactory(
      (i) => HomeUserCase(
        i.get(),
        i.get(),
      ),
    );
  }

  static void _injectUtils() {
    Cubes.registerLazySingleton<NetworkClient>(
      (i) => DioNetworkProvider(baseUrl: 'http://104.131.18.84/'),
    );
    Cubes.registerLazySingleton(
      (i) => PokemonRepository(i.get()),
    );
    Cubes.registerLazySingleton(
      (i) => PokemonTypeRepository(i.get()),
    );
  }
}
