import 'package:flutter/material.dart';

class Sizes {

  final BuildContext context;

  Sizes({required this.context});


  // var _size, _height, _width;

  get size => MediaQuery.of(context).size;

  get height => size.height;

  get width => size.width;

  double appBarHeight = AppBar().preferredSize.height.toDouble();

  get isPortraitMode => size.height > size.width;

  get isSquareMode => size.height == size.width;

  double calculateTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(); // Lays out the text to calculate its size
    return textPainter.size.width; // Returns the width
  }

}