import 'package:ecoschedule/domain/town.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Location extends Equatable {
  final int id;
  final String name;
  final Town town;
  final String streetName;
  final String houseNumber;
  final String sides;
  final String group;

  const Location(
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
      "Location { $id, $name, $town, $streetName $houseNumber, $sides, $group }";

  Location copyWith({int id, String name}) => Location(
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

  static Location fromMap(Map<String, dynamic> m) => Location(
      name: m["name"],
      town: Town(
          id: m["town"]["id"],
          name: m["town"]["name"],
          district: m["town"]["district"],
          province: m["town"]["province"]),
      streetName: m["streetName"],
      houseNumber: m["houseNumber"],
      sides: m["sides"],
      group: m["group"]);
}
