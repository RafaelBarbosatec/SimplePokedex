import 'package:bsev/bloc_communication.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:simple_pokedex/pages/home/bloc/home_events.dart';

class Header extends StatelessWidget {
  final BlocCommunication<HomeStreams> communication;

  const Header({Key key, this.communication}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 20),
              child: Text(
                'SimplePokedex',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.grey[700]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 20),
              child: Image.asset(
                'assets/pokebola_img.png',
                height: 30,
                width: 30,
              ),
            )
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (name) {
                  communication.dispatcher(SearchName(name));
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search per name'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
