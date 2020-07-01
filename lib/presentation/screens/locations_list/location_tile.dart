import 'package:ecoschedule/domain/location.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LocationTile extends StatelessWidget {

  final Location location;

  const LocationTile({this.location});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        title: Text(
          location.name,
          style: GoogleFonts.monda(),
        ),
        subtitle: Text(
          "${location.town.name}, ${location.streetName} ${location.houseNumber}",
          style: GoogleFonts.monda(),
        ),
        leading: CircleAvatar(
          child: Text(
            location.streetName.substring(0, 2).toUpperCase(),
            style: GoogleFonts.monda(),
          ),
        ));
  }
}
