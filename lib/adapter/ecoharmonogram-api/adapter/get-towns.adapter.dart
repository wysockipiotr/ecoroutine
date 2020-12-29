import 'dart:convert';

import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart'
    show TownDto;
import 'package:ecoschedule/config/config.dart'
    show ECOHARMONOGRAM_API_BASE_URL;
import "package:http/http.dart" as http;

Future<List<TownDto>> getTowns({String townNamePattern}) async {
  final response = await http.post(
    "$ECOHARMONOGRAM_API_BASE_URL?action=getTowns&townName=$townNamePattern",
  );
  if (response.statusCode != 200) {
    return [];
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List towns = payload["towns"];
  return List<TownDto>.from(towns.map((town) => TownDto(
      id: town["id"],
      name: town["name"],
      district: town["district"],
      province: town["province"])));
}
