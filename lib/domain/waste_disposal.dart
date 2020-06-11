import 'package:flutter/widgets.dart';

class WasteDisposal {
  final DateTime date;
  final String name;
  final Color color;

  const WasteDisposal({this.name, this.color, this.date});

  @override
  String toString() => "WasteDisposal($name, $date)";
}
