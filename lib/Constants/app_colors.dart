import 'package:flutter/material.dart';

class ColorConstants {
  static Color startColor = Color.fromRGBO(43, 163, 203, 1);
  static Color endColor = Color.fromRGBO(184, 134, 213, 1);

  static Color underweightColor = Colors.blue;
  static Color normalWeightColor = Colors.green;
  static Color overweightColor = Colors.yellow;
  static Color obeseColor = Colors.red;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
