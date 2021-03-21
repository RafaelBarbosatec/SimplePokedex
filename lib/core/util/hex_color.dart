import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String? hexColor) {
    if (hexColor == null) return 0;
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor) : super(_getColorFromHex(hexColor));
}
