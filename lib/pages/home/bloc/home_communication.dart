import 'package:bsev/bsev.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class HomeCommunication extends Communication {
  final queryDebounce = BehaviorSubjectCreate<String>();
  final progress = BehaviorSubjectCreate<bool>(initValue: false);
  final showEmpty = BehaviorSubjectCreate<bool>(initValue: false);
  final pokemons = BehaviorSubjectCreate<List<Pokemon>>();
  final pokemonsTypes = BehaviorSubjectCreate<List<PokemonType>>();

  @override
  void dispose() {
    progress.close();
    pokemons.close();
    pokemonsTypes.close();
    showEmpty.close();
    queryDebounce.close();
    super.dispose();
  }
}
