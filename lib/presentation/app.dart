import 'package:ecoschedule/presentation/screens/home/home_screen.dart';
import 'package:ecoschedule/presentation/screens/locations_list/state/location_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationListBloc>(
      create: (context) => LocationListBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ecoschedule',
          theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.grey,
              errorColor: Colors.red[300],
              accentColor: Colors.grey[300],
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textSelectionHandleColor: Colors.grey),
          home: HomeScreen()),
    );
  }
}
