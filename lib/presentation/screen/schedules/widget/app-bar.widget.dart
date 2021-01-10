import 'dart:ui';

import 'package:ecoroutine/domain/location/location.dart';
import 'package:ecoroutine/presentation/screen/locations/locations.screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchedulesAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final ValueNotifier<LocationEntity> activeLocation;

  SchedulesAppBar({Key key, this.activeLocation})
      : preferredSize = const Size.fromHeight(75),
        super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 1,
      toolbarHeight: 75,
      centerTitle: true,
      title: InkWell(
        borderRadius: BorderRadius.circular(6.0),
        onTap: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LocationsScreen()));
        },
        child: ValueListenableBuilder(
          valueListenable: activeLocation,
          builder: (context, activeLocation, _) => _buildAnimatedSwitcher(
            child: _buildLocationTitle(activeLocation),
          ),
        ),
      ));

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
