import 'package:equatable/equatable.dart';

class TownDto extends Equatable {
  final String id;
  final String name;
  final String province;
  final String district;

  const TownDto({this.id, this.name, this.province, this.district});

  @override
  List<Object> get props => [id, name, province, district];

  @override
  String toString() => "Town { $id, $name, $province, $district }";
}
