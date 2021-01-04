import 'package:ecoroutine/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.grey[200], // navigation bar color
    statusBarColor: Colors.grey[50], // status bar color
  ));

  runApp(App());
}
