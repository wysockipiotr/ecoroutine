import 'dart:convert';

import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show SchedulePeriodDto;
import 'package:ecoroutine/config/config.dart' show ECOHARMONOGRAM_API_BASE_URL;
import "package:http/http.dart" as http;

Future<SchedulePeriodDto> getSchedulePeriods({String townId}) async {
  final response = await http.post(
      "$ECOHARMONOGRAM_API_BASE_URL?action=getSchedulePeriods&townId=$townId");
  if (response.statusCode != 200) {
    throw Exception();
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List schedulePeriods = payload["schedulePeriods"];

  return List<SchedulePeriodDto>.from(schedulePeriods.map((schedulePeriod) =>
      SchedulePeriodDto(
          id: schedulePeriod["id"],
          fromDate: DateTime.parse(schedulePeriod["startDate"]),
          toDate: DateTime.parse(schedulePeriod["endDate"]),
          changeDate: DateTime.parse(schedulePeriod["changeDate"])))).last;
  // .firstWhere((SchedulePeriodDto schedulePeriod) {
  // return true;
  // final now = DateTime.now();
  // return now.isAfter(schedulePeriod.fromDate) &&
  //     now.isBefore(schedulePeriod.toDate);
  // });
}
