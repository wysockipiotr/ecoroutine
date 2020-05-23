import 'package:ecoschedule/presentation/screens/locations_list/location_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My locations", style: GoogleFonts.monda()),
      ),
      body: ListView(
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            LocationTile(name: "House ${i + 1}", address: "00-000 City")
        ],
      ),
    );
  }
}
