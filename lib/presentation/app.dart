import 'package:ecoroutine/bloc/schedules/schedules.dart';
import 'package:ecoroutine/config/config.dart';
import 'package:ecoroutine/presentation/screen/add_location/enum/enum.dart';
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
          onGenerateRoute: (settings) {
            // if (settings.name == "/schedules") {}
            if (settings.name == LocationsScreen.RouteName) {
              return MaterialPageRoute(builder: (context) => LocationsScreen());
            }
            if (settings.name == AddLocationScreen.RouteName) {
              return MaterialPageRoute(
                  builder: (context) => AddLocationScreen());
            }
            return MaterialPageRoute(
                builder: (context) =>
                    BlocBuilder<SchedulesCubit, SchedulesState>(
                      buildWhen: (previous, next) => !(next is SchedulesError),
                      builder: (context, schedulesState) {
                        if (schedulesState is SchedulesReady) {
                          if (schedulesState.locationsToDisposals.isEmpty) {
                            return WelcomeScreen();
                          }
                          return SchedulesScreen(
                              locationsToDisposals:
                                  schedulesState.locationsToDisposals,
                              initialPage: settings.arguments is int
                                  ? settings.arguments
                                  : 0);
                        } else if (schedulesState is NoLocations) {
                          return WelcomeScreen();
                        } else if (SchedulesState is SchedulesError) {
                          return LoadingCurtainScreen();
                        } else {
                          return LoadingCurtainScreen();
                        }
                      },
                    ));
          },
          initialRoute: SchedulesScreen.RouteName,
        ));
  }
}
