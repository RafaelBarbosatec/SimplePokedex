import 'package:flutter/material.dart';
import 'package:simple_pokedex/di/dependency_injector.dart';
import 'package:simple_pokedex/pages/home/home_page.dart';

void main() {
  injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
