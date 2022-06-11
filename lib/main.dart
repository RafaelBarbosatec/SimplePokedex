import 'package:flutter/material.dart';
import 'package:simple_pokedex/core/di/dependency_injector.dart';
import 'package:simple_pokedex/presentation/pages/home/home_page.dart';

void main() {
  DI.inject();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimplePokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
