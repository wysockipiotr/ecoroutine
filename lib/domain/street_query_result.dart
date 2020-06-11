import 'package:equatable/equatable.dart';

class StreetIdsQueryResult extends Equatable {
  final String name;
  final List<String> ids;

  const StreetIdsQueryResult({this.name, this.ids});

  @override
  List<Object> get props => [name, ids];
}

class StreetQueryResult extends Equatable {
  final String id;
  final String name;
  final String sides;
  final String group;
  final List<String> numbers;

  const StreetQueryResult(
      {this.id, this.name, this.sides, this.group, this.numbers = const []});

  @override
  List<Object> get props => [id, name, sides, group, numbers];

  @override
  String toString() =>
      "StreetQueryResult { $id, $name, $sides, $group, $numbers }";
}
