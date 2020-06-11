import 'package:ecoschedule/data/persistence/dao.dart';
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
      body: FutureBuilder(
          future: LocationDao().getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Location> locations = snapshot.data;

              return ListView(
                children: locations
                    .map(
                        (Location location) => LocationTile(location: location))
                    .toList(),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),
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
