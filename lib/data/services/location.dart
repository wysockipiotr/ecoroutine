import 'dart:convert';

import 'package:ecoschedule/domain/city.dart';
import 'package:ecoschedule/domain/street.dart';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

const BASE_URL = "https://ecoharmonogram.pl/api/api.php";

class SchedulePeriod {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime changeDate;

  const SchedulePeriod({this.id, this.fromDate, this.toDate, this.changeDate});
}

Future<List<City>> getCities({String cityName}) async {
  final response = await http.post(
    "$BASE_URL?action=getTowns&townName=$cityName",
  );
  if (response.statusCode != 200) {
    return [];
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List towns = payload["towns"];
  return List<City>.from(towns.map((town) => City(
      id: town["id"],
      name: town["name"],
      district: town["district"],
      province: town["province"])));
}

Future<SchedulePeriod> getSchedulePeriods({String cityId}) async {
  final response =
      await http.post("$BASE_URL?action=getSchedulePeriods&townId=$cityId");
  if (response.statusCode != 200) {
    throw Exception();
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List schedulePeriods = payload["schedulePeriods"];

  return List<SchedulePeriod>.from(schedulePeriods.map((schedulePeriod) =>
          SchedulePeriod(
              id: schedulePeriod["id"],
              fromDate: DateTime.parse(schedulePeriod["startDate"]),
              toDate: DateTime.parse(schedulePeriod["endDate"]),
              changeDate: DateTime.parse(schedulePeriod["changeDate"]))))
      .firstWhere((SchedulePeriod schedulePeriod) {
    final now = DateTime.now();
    return now.isAfter(schedulePeriod.fromDate) &&
        now.isBefore(schedulePeriod.toDate);
  });
}

Future<String> getStreets(
    {@required String cityId,
    @required String schedulePeriodId,
    String streetName = "",
    String houseNumber = "",
    List<String> streetIds = const []}) async {
  final streetIdsParam = streetIds.join(",");
  final url =
      "$BASE_URL?action=getStreets&townId=$cityId&schedulePeriodId=$schedulePeriodId&streetName=$streetName&number=$houseNumber&groupId=1&choosedStreetIds=$streetIdsParam";
  final response = await http.post(url);
  if (response.statusCode != 200) {
    return "error";
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  return payload.toString();
}

Future<List<StreetIds>> getStreetIds(
    {String cityId,
    String schedulePeriodId,
    String streetNamePattern,
    String houseNumber}) async {
  final url =
      "$BASE_URL?action=getStreets&townId=$cityId&schedulePeriodId=$schedulePeriodId&streetName=$streetNamePattern&number=$houseNumber";
  final response = await http.post(url);
  if (response.statusCode != 200) {
    return const [];
  }
  try {
    final Map payload = json.decode(utf8.decode(response.bodyBytes));
    final List streets = payload["streets"];
    final Iterable streetNames = streets.map((street) => street["name"]);

    final Map streetNamesToOccurences = Map();
    for (final name in streetNames) {
      streetNamesToOccurences[name] = (streetNamesToOccurences[name] ?? 0) + 1;
    }

    return List<StreetIds>.from(streetNamesToOccurences.entries.map((entry) {
      final streetName = entry.key;
      final occurences = entry.value;

      if (occurences > 1) {
        return StreetIds(
            name: streetName,
            ids: List<String>.from(streets
                .where((street) => street["name"] == streetName)
                .map((street) => street["id"])));
      } else {
        return StreetIds(
            name: streetName,
            ids: List<String>.from(streets
                .firstWhere((street) => street["name"] == streetName)["id"]
                .split(",")));
      }
    }));
  } on FormatException {
    return const [];
  }
}
