import 'dart:convert';

import 'package:ecoschedule/data/services/api/api.dart';
import 'package:ecoschedule/domain/schedule_period.dart';
import "package:http/http.dart" as http;

Future<SchedulePeriod> getSchedulePeriods({String townId}) async {
  final response =
      await http.post("$BASE_URL?action=getSchedulePeriods&townId=$townId");
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
