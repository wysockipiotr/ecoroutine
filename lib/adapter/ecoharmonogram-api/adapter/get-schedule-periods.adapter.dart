import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show SchedulePeriodDto;
import 'package:ecoroutine/adapter/ecoharmonogram-api/helper/helper.dart';

Future<SchedulePeriodDto> getSchedulePeriods({String townId}) async {
  final schedulePeriods = (await ecoharmonogramRequest(
      {"action": "getSchedulePeriods", "townId": townId}))["schedulePeriods"];
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
