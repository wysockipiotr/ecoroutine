import 'dart:ui';

import 'package:ecoroutine/domain/location/location.dart';
import 'package:ecoroutine/presentation/screen/locations/locations.screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchedulesAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final ValueChanged<int> onSchedulesPageChange;
  final ValueNotifier<LocationEntity> activeLocation;
  final ValueNotifier<bool> elevated;

  SchedulesAppBar(
      {Key key, this.activeLocation, this.onSchedulesPageChange, this.elevated})
      : preferredSize = const Size.fromHeight(75),
        super(key: key);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: elevated,
        builder: (context, elevated, _) => AppBar(
            // leading: null,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).canvasColor,
            elevation: elevated ? 1.0 : 0.0,
            toolbarHeight: 75,
            centerTitle: true,
            title: InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () async {
                await Navigator.pushNamed(context, LocationsScreen.RouteName);
              },
              child: ValueListenableBuilder(
                valueListenable: activeLocation,
                builder: (context, activeLocation, _) => _buildAnimatedSwitcher(
                  child: _buildLocationTitle(activeLocation),
                ),
              ),
            )),
      );

  Widget _buildAnimatedSwitcher({Widget child}) => AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: child);

  Widget _buildLocationTitle(LocationEntity location) => Padding(
        key: ValueKey<LocationEntity>(location),
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: <Widget>[
            Text(location.name,
                style: GoogleFonts.monda().copyWith(fontSize: 16.0)),
            Text(
                "${location.town.name}, ${location.streetName} ${location.houseNumber}",
                style: GoogleFonts.monda().copyWith(fontSize: 12.0))
          ],
        ),
      );
}
