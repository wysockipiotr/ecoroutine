import 'package:ecoschedule/config/config.dart';
import 'package:ecoschedule/presentation/screen/schedules/bloc/bloc.dart';
import 'package:ecoschedule/presentation/screen/schedules/schedules.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen/locations/bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationListBloc>(
            create: (context) =>
                LocationListBloc()..add(LocationListEvent.ReloadLocations)),
        BlocProvider<SchedulesBloc>(
            create: (context) =>
                SchedulesBloc(BlocProvider.of<LocationListBloc>(context)))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: APP_TITLE,
          theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.grey,
              errorColor: Colors.red[300],
              accentColor: Colors.grey[300],
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textSelectionHandleColor: Colors.grey),
          home: SchedulesScreen()),
    );
  }
}
