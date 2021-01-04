import 'dart:io';

import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart'
    show TownDto;
import 'package:ecoroutine/adapter/ecoharmonogram-api/helper/helper.dart';

Future<List<TownDto>> getTowns({String townNamePattern}) async {
  try {
    final towns = (await ecoharmonogramRequest(
        {"action": "getTowns", "townName": townNamePattern}))["towns"];
    return List<TownDto>.from(towns.map((town) => TownDto(
        id: town["id"],
        name: town["name"],
        district: town["district"],
        province: town["province"])));
  } on SocketException {
    rethrow;
  } on Exception {
    return const [];
  }
}
