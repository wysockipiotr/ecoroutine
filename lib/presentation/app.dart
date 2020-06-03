import 'package:ecoschedule/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ecoschedule',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          errorColor: Colors.red[300],
          accentColor: Colors.grey[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textSelectionHandleColor: Colors.grey),
      home: HomeScreen(),
    );
  }
}
