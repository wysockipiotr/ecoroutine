class StreetIds {
  final String name;
  final List<String> ids;

  const StreetIds({this.name, this.ids});
}

class Street {
  final String id;
  final String name;
  final String sides;
  final String group;
  final List<String> numbers;

  const Street(
      {this.id, this.name, this.sides, this.group, this.numbers = const []});
}
