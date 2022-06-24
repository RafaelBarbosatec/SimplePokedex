import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 24/06/22
class SnackBarAction extends CubeAction {
  final String text;

  SnackBarAction(this.text);

  @override
  void execute(BuildContext context) {
    context.showSnackBar(SnackBar(content: Text(text)));
  }
}
