import 'dart:convert';

import 'package:ecoschedule/data/services/api/api.dart';
import 'package:ecoschedule/domain/town.dart';
import "package:http/http.dart" as http;

Future<List<Town>> getTowns({String townNamePattern}) async {
  final response = await http.post(
    "$BASE_URL?action=getTowns&townName=$townNamePattern",
  );
  if (response.statusCode != 200) {
    return [];
  }
  final Map payload = json.decode(utf8.decode(response.bodyBytes));
  final List towns = payload["towns"];
  return List<Town>.from(towns.map((town) => Town(
      id: town["id"],
      name: town["name"],
      district: town["district"],
      province: town["province"])));
}
