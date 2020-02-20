import 'package:bsev/bsev.dart';
import 'package:simple_pokedex/repository/pokemon/model/pokemon_type.dart';

class SelectType extends EventsBase {
  final PokemonType type;

  SelectType(this.type);
}
