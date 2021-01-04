import 'dart:io';

import "package:collection/collection.dart";
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show WasteDisposalDto;
import 'package:ecoroutine/adapter/ecoharmonogram-api/helper/helper.dart';
import 'package:ecoroutine/utility/utility.dart';

Future<List<WasteDisposalDto>> getSchedule(
    {String streetId = "1690930",
    String houseNumber = "1",
    bool futureOnly = true}) async {
  try {
    final payload = (await ecoharmonogramRequest({
      "action": "getSchedules",
      "streetId": streetId,
      "number": houseNumber
    }));
    final List schedules = payload["schedules"];
    final List descriptions = payload["scheduleDescription"];

    final schedule = List<WasteDisposalDto>.from(schedules.expand((schedule) {
      final descriptionId = schedule["scheduleDescriptionId"];
      final description = descriptions
          .firstWhere((description) => description["id"] == descriptionId);

      return schedule["days"].split(";").map(int.parse).map((day) =>
          WasteDisposalDto(
              name: description["name"],
              date: DateTime(int.parse(schedule["year"]),
                  int.parse(schedule["month"]), day),
              color: fromHexString(description["color"])));
    })).where((disposal) {
      final now = DateTime.now();
      final yesterday =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
      return !futureOnly || disposal.date.isAfter(yesterday);
    }).toList();

    return (schedule..sort((lhs, rhs) => lhs.date.compareTo(rhs.date)));
  } on SocketException {
    rethrow;
  } on Exception {
    return const [];
  }
}

Map<DateTime, List<WasteDisposalDto>> groupByDate(
        Iterable<WasteDisposalDto> disposals) =>
    groupBy(
        disposals,
        (disposal) => DateTime(
            disposal.date.year, disposal.date.month, disposal.date.day));
