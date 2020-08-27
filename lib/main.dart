import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';
import 'package:simple_pokedex/di/dependency_injector.dart';
import 'package:simple_pokedex/pages/home/home_page.dart';

void main() {
  injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final cubeLocation = CubesLocalizationDelegate(
    [
      Locale('en', 'US'),
      Locale('pt', 'BR'),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimplePokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: cubeLocation.delegates, // see here
      supportedLocales: cubeLocation.supportedLocations, // see here
      home: HomePage(),
    );
  }
}
