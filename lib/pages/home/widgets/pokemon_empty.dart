import 'package:flutter/material.dart';

class PokemonEmpty extends StatelessWidget {
  final String msg;

  const PokemonEmpty({Key key, this.msg = "Not found"}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/simbol_pokemon.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              msg,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}
