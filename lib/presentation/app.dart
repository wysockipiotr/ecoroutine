import 'package:ecoroutine/bloc/schedules/schedules.dart';
import 'package:ecoroutine/config/config.dart';
import 'package:ecoroutine/presentation/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SchedulesCubit>(
              create: (context) => SchedulesCubit()..reload())
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
              buildWhen: (previous, next) => !(next is SchedulesError),
              builder: (context, schedulesState) {
                if (schedulesState is SchedulesReady) {
                  if (schedulesState.locationsToDisposals.isEmpty) {
                    return WelcomeScreen();
                  }
                  return SchedulesScreen(
                      locationsToDisposals:
                          schedulesState.locationsToDisposals);
                } else if (schedulesState is NoLocations) {
                  return WelcomeScreen();
                } else if (SchedulesState is SchedulesError) {
                  return LoadingCurtainScreen();
                } else {
                  return LoadingCurtainScreen();
                }
              },
            )));
  }
}
