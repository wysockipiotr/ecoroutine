import 'package:equatable/equatable.dart';

class Town extends Equatable {
  final String id;
  final String name;
  final String province;
  final String district;

  const Town({this.id, this.name, this.province, this.district});

  @override
  List<Object> get props => [id, name, province, district];

  @override
  String toString() => "Town { $id, $name, $province, $district }";
}
