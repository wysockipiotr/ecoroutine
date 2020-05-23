import 'package:flutter/material.dart';

Color randomColor() {
  return ([
    Colors.yellow[800],
    Colors.brown,
    Colors.red,
    Colors.deepPurple,
    Colors.green,
    Colors.blue,
    Colors.grey
  ]..shuffle())
      .first;
}
