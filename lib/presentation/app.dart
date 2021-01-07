import 'package:ecoroutine/config/config.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/page.bloc.dart';
import 'package:ecoroutine/presentation/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen/locations/bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LocationListCubit>(
              create: (context) => LocationListCubit()..reloadLocations()),
          BlocProvider<SchedulesCubit>(
              create: (context) =>
                  SchedulesCubit(BlocProvider.of<LocationListCubit>(context))),
          BlocProvider<PageCubit>(
              create: (context) => PageCubit()..switchPage(0))
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: APP_TITLE,
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.grey,
                errorColor: Colors.red[300],
                accentColor: Colors.grey[300],
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textSelectionHandleColor: Colors.grey),
            home: BlocBuilder<SchedulesCubit, SchedulesState>(
              builder: (context, state) {
                if (state is SchedulesReady) {
                  if (state.locationsToDisposals.isEmpty) {
                    return WelcomeScreen();
                  }
                  return SchedulesScreen(
                      locationsToDisposals: state.locationsToDisposals);
                } else if (state is NoLocations) {
                  return WelcomeScreen();
                } else {
                  return LoadingCurtainScreen();
                }
              },
            )));
  }
}
