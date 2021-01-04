import 'package:ecoroutine/config/config.dart' show ECOHARMONOGRAM_API_BASE_URL;
import "package:http/http.dart" as http;
import 'dart:convert';

Future<Map> ecoharmonogramRequest(Map<String, String> params) async {
  print("request to");
  final queryString =
      params.entries.map((entry) => "${entry.key}=${entry.value}").join("&");
  final response = await http.post("$ECOHARMONOGRAM_API_BASE_URL?$queryString");
  if (response.statusCode != 200) {
    throw Exception();
  }
  print(utf8.decode(response.bodyBytes));
  return json.decode(utf8.decode(response.bodyBytes));
}
