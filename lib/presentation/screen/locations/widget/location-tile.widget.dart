import 'package:ecoroutine/domain/location/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationTile extends StatelessWidget {
  final LocationEntity location;
  final VoidCallback onTap;

  const LocationTile({this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
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
