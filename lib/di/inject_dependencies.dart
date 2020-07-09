import 'package:bsev/bsev.dart';
import 'package:dio/dio.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';

void injectDependencies() {
  injectUtils();
  injectBloCs();
}

void injectBloCs() {
  registerBloc<HomeBloc, HomeCommunication>(
    (i) => HomeBloc(i.get()),
    () => HomeCommunication(),
  );
}

void injectUtils() {
  registerSingletonDependency(
    (i) => Dio(BaseOptions(baseUrl: 'http://104.131.18.84/')),
  );
  registerSingletonDependency((i) => PokemonRepository(i.get()));
}
