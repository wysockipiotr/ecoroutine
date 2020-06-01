import 'package:ecoschedule/domain/location.dart';
import 'package:ecoschedule/presentation/screens/add_location/add_location_screen.dart';
import 'package:ecoschedule/presentation/screens/locations_list/location_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text("Locations", style: GoogleFonts.monda()),
      ),
      body: ListView(
        // padding: EdgeInsets.all(16.0),
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            LocationTile(
                location: Location(
                    streetId: "0",
                    cityId: "2",
                    city: "City",
                    houseNumber: (i + 10).toString(),
                    name: "House ${'ABCDEFG'[i]}",
                    street: "Street"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddLocationScreen()));
        },
      ),
    );
  }
}
