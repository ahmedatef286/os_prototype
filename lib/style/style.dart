import 'package:flutter/material.dart';

class CustomStyle {
  static final _ColorPalette colorPalette = _ColorPalette();
  static final _FontSizes fontSizes = _FontSizes();
}

class _ColorPalette {
//write your colors here
  Color darkGrey = Color(0xff191919);
  Color midGrey = Color(0xff202020);
  Color lightGrey = Color.fromARGB(255, 45, 45, 45);
  Color fullWhite = Color(0xffffffff);
  Color dimWhite = Color.fromARGB(255, 157, 157, 157);
}

class _FontSizes {
  //write common font size here
  double smallFont = 12;
  double subMediumFont = 16;
  double mediumFont = 22;
  double largeFont = 32;
}
