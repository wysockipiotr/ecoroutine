import 'package:flutter/widgets.dart';

class WasteDisposalDto {
  final DateTime date;
  final String name;
  final Color color;

  const WasteDisposalDto({this.name, this.color, this.date});

  @override
  String toString() => "WasteDisposal($name, $date)";
}
