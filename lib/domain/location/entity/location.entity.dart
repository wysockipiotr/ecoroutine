import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart'
    show TownDto;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class LocationEntity extends Equatable {
  final int id;
  final String name;
  final TownDto town;
  final String streetName;
  final String houseNumber;
  final String sides;
  final String group;

  const LocationEntity(
      {this.id,
      @required this.name,
      @required this.town,
      @required this.streetName,
      @required this.houseNumber,
      this.sides,
      this.group});

  @override
  List<Object> get props =>
      [id, name, town, streetName, houseNumber, sides, group];

  @override
  String toString() =>
      "LocationEntity { $id, $name, $town, $streetName $houseNumber, $sides, $group }";

  LocationEntity copyWith({int id, String name}) => LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      town: town,
      streetName: streetName,
      houseNumber: houseNumber,
      sides: sides,
      group: group);

  Map<String, dynamic> toMap() => {
        "name": name,
        "town": {
          "id": town.id,
          "name": town.name,
          "district": town.district,
          "province": town.province
        },
        "streetName": streetName,
        "houseNumber": houseNumber,
        "sides": sides,
        "group": group
      };

  static LocationEntity fromMap(Map<String, dynamic> m) => LocationEntity(
      name: m["name"],
      town: TownDto(
          id: m["town"]["id"],
          name: m["town"]["name"],
          district: m["town"]["district"],
          province: m["town"]["province"]),
      streetName: m["streetName"],
      houseNumber: m["houseNumber"],
      sides: m["sides"],
      group: m["group"]);
}
