import 'dart:convert';

import 'package:ecoschedule/domain/city.dart';
import "package:http/http.dart" as http;

const BASE_URL = "https://ecoharmonogram.pl/api/api.php";

Future<List<City>> getCities({String cityName}) async {
  final response = await http.post(
    "$BASE_URL?action=getTowns&townName=$cityName",
  );
  if (response.statusCode != 200) {
    return [];
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List towns = payload["towns"];
  return List<City>.from(towns.map((town) => City(
      id: town["id"],
      name: town["name"],
      district: town["district"],
      province: town["province"])));
}
