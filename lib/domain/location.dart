import 'package:flutter/foundation.dart';

class Location {
  final String name;
  final String city;
  final String cityId;
  final String street;
  final String streetId;
  final String houseNumber;
  final bool isActive;

  const Location(
      {this.name,
      @required this.cityId,
      this.city,
      @required this.streetId,
      this.street,
      @required this.houseNumber,
      this.isActive = true});
}

