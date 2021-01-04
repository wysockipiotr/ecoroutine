import 'dart:convert';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show StreetIdsQueryResultDto, StreetQueryResultDto;
import 'package:ecoroutine/config/config.dart' show ECOHARMONOGRAM_API_BASE_URL;
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

Future<List<StreetIdsQueryResultDto>> getStreetIds(
    {String townId,
    String schedulePeriodId,
    String streetNamePattern,
    String houseNumber}) async {
  final url =
      "$ECOHARMONOGRAM_API_BASE_URL?action=getStreets&townId=$townId&schedulePeriodId=$schedulePeriodId&streetName=$streetNamePattern&number=$houseNumber";
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

    return List<StreetIdsQueryResultDto>.from(
        streetNamesToOccurences.entries.map((entry) {
      final streetName = entry.key;
      final occurences = entry.value;

      if (occurences > 1) {
        return StreetIdsQueryResultDto(
            name: streetName,
            ids: List<String>.from(streets
                .where((street) => street["name"] == streetName)
                .map((street) => street["id"])));
      } else {
        return StreetIdsQueryResultDto(
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

Future<List<StreetQueryResultDto>> getStreets(
    {@required String townId,
    @required String schedulePeriodId,
    String streetName = "",
    String houseNumber = "",
    List<String> streetIds = const []}) async {
  final streetIdsParam = streetIds.join(",");
  final url =
      "$ECOHARMONOGRAM_API_BASE_URL?action=getStreets&townId=$townId&schedulePeriodId=$schedulePeriodId&streetName=$streetName&number=$houseNumber&groupId=1&choosedStreetIds=$streetIdsParam";
  final response = await http.post(url);
  if (response.statusCode != 200) {
    return [];
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));

  return List<StreetQueryResultDto>.from(payload["streets"].map((street) =>
      StreetQueryResultDto(
          id: street["id"],
          name: street["name"],
          sides: street["sides"],
          group: street["g1"],
          numbers: street["numbers"].split(","))));
}
