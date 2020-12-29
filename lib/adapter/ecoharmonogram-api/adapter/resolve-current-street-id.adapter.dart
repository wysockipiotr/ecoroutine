import 'package:ecoschedule/adapter/ecoharmonogram-api/adapter/adapter.dart'
    show getStreetIds, getStreets, getSchedulePeriods;
import 'package:ecoschedule/domain/location/location.dart' show LocationEntity;

Future<String> resolveCurrentStreetId({LocationEntity location}) async {
  final schedulePeriod = await getSchedulePeriods(townId: location.town.id);
  final streetIds = await getStreetIds(
      townId: location.town.id,
      schedulePeriodId: schedulePeriod.id,
      streetNamePattern: location.streetName,
      houseNumber: location.houseNumber);
  final streets = (await getStreets(
          townId: location.town.id,
          schedulePeriodId: schedulePeriod.id,
          streetIds: streetIds.first.ids,
          houseNumber: location.houseNumber))
      .where(
          (street) => location.sides == null || street.sides == location.sides)
      .where(
          (street) => location.group == null || street.group == location.group)
      .toList();
  if (streets.isEmpty) {
    return null;
  }
  if (streets.length == 1) {
    return streets.first.id;
  }
  return streets
      .firstWhere((street) => street.numbers.contains(location.houseNumber))
      .id;
}
