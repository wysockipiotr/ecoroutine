import 'dart:io';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show StreetIdsQueryResultDto, StreetQueryResultDto;
import 'package:ecoroutine/adapter/ecoharmonogram-api/helper/helper.dart';
import 'package:flutter/foundation.dart';

Future<List<StreetIdsQueryResultDto>> getStreetIds(
    {String townId,
    String schedulePeriodId,
    String streetNamePattern,
    String houseNumber}) async {
  try {
    final streets = (await ecoharmonogramRequest({
      "action": "getStreets",
      "townId": townId,
      "schedulePeriodId": schedulePeriodId,
      "streetName": streetNamePattern,
      "number": houseNumber
    }))["streets"];
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
  } on SocketException {
    rethrow;
  } on Exception {
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

  try {
    final payload = (await ecoharmonogramRequest({
      "action": "getStreets",
      "townId": townId,
      "schedulePeriodId": schedulePeriodId,
      "streetName": streetName,
      "number": houseNumber,
      "groupId": "1",
      "choosedStreetIds": streetIdsParam
    }));
    // print(payload);

    return List<StreetQueryResultDto>.from(payload["streets"].map((street) =>
        StreetQueryResultDto(
            id: street["id"],
            name: street["name"],
            sides: street["sides"],
            group: street["g1"],
            numbers: street["numbers"].split(","))));
  } on SocketException {
    rethrow;
  } on Exception {
    return const [];
  }
}
