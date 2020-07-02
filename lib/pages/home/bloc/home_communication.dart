import 'package:bsev/bsev.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class HomeCommunication extends CommunicationBase {
  final queryDebounce = BehaviorSubjectCreate<String>();
  var progress = BehaviorSubjectCreate<bool>(initValue: false);
  var showEmpty = BehaviorSubjectCreate<bool>(initValue: false);
  var pokemons = BehaviorSubjectCreate<List<Pokemon>>();
  var pokemonsTypes = BehaviorSubjectCreate<List<PokemonType>>();

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
