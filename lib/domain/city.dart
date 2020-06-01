class City {
  final String id;
  final String name;
  final String province;
  final String district;

  const City({this.id, this.name, this.province, this.district});

  @override
  String toString() => "City(id:$id, name:$name)";
}
