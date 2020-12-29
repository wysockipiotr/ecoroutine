import 'package:equatable/equatable.dart';

class StreetQueryResultDto extends Equatable {
  final String id;
  final String name;
  final String sides;
  final String group;
  final List<String> numbers;

  const StreetQueryResultDto(
      {this.id, this.name, this.sides, this.group, this.numbers = const []});

  @override
  List<Object> get props => [id, name, sides, group, numbers];

  @override
  String toString() =>
      "StreetQueryResult { $id, $name, $sides, $group, $numbers }";
}
