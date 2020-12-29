import 'dart:ui';

Color fromHexString(String hex) {
  if (hex.length == 7) {
    hex = hex.substring(1);
  } else if (hex.length == 9) {
    hex = hex.substring(3);
  }
  return Color(int.parse("ff" + hex, radix: 16));
}
