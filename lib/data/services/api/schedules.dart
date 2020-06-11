import 'dart:convert';
import 'dart:ui';

import "package:collection/collection.dart";
import 'package:ecoschedule/data/services/api/api.dart';
import 'package:ecoschedule/domain/waste_disposal.dart';
import 'package:ecoschedule/utils/color.dart';
import "package:http/http.dart" as http;

Future<List<WasteDisposal>> getSchedule(
    {String streetId = "1690930",
    String houseNumber = "1",
    bool futureOnly = true}) async {
  final response = await http.post(
    "$BASE_URL?action=getSchedules&streetId=$streetId&number=$houseNumber",
  );
  if (response.statusCode != 200) {
    throw Exception("Could not fetch");
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List schedules = payload["schedules"];
  final List descriptions = payload["scheduleDescription"];

  final schedule = List<WasteDisposal>.from(schedules.expand((schedule) {
    final descriptionId = schedule["scheduleDescriptionId"];
    final description = descriptions
        .firstWhere((description) => description["id"] == descriptionId);

    return schedule["days"].split(";").map(int.parse).map((day) =>
        WasteDisposal(
            name: description["name"],
            date: DateTime(
                int.parse(schedule["year"]), int.parse(schedule["month"]), day),
            color: fromHexString(description["color"])));
  })).where((disposal) {
    final now = DateTime.now();
    final yesterday =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
    return !futureOnly || disposal.date.isAfter(yesterday);
  }).toList();

  return (schedule..sort((lhs, rhs) => lhs.date.compareTo(rhs.date)));
}

Map<DateTime, List<WasteDisposal>> groupByDate(
        Iterable<WasteDisposal> disposals) =>
    groupBy(
        disposals,
        (disposal) => DateTime(
            disposal.date.year, disposal.date.month, disposal.date.day));
