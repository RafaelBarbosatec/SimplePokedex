import 'package:bsev/bsev.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/repository/pokemon/pokemon_repository.dart';
import 'package:simple_pokedex/util/con.dart';

void injectDependencies() {
  injectUtils();
  injectBloCs();
}

void injectBloCs() {
  registerBloc<HomeBloc, HomeStreams>(
      (i) => HomeBloc(i.getDependency()), () => HomeStreams());
}

void injectUtils() {
  registerSingleton((i) => Con('http://104.131.18.84/', debug: true));
  registerSingleton((i) => PokemonRepository(i.getDependency()));
}
