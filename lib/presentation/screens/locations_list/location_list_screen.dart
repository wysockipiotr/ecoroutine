import 'package:ecoschedule/data/persistence/dao.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:ecoschedule/presentation/screens/add_location/add_location_screen.dart';
import 'package:ecoschedule/presentation/screens/locations_list/location_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationDao = LocationDao();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text("Locations", style: GoogleFonts.monda()),
      ),
      body: FutureBuilder(
          future: locationDao.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Location> locations = snapshot.data;

              return ListView(
                children: locations
                    .map((Location location) => Dismissible(
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final deletionConfirmed =
                                  await _showConfirmDeleteDialog(
                                          context, location.name) ??
                                      false;
                              if (deletionConfirmed) {
                                await locationDao.delete(location.id);
                              }
                              return deletionConfirmed;
                            } else {
                              return false;
                            }
                          },
                          background: Container(
                            color: Colors.grey[700],
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 36,
                                  ),
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 36,
                                  ),
                                  Text("Edit",
                                      style: GoogleFonts.monda(fontSize: 16))
                                ]),
                          ),
                          secondaryBackground: Container(
                              color: Colors.red,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Delete",
                                        style: GoogleFonts.monda(fontSize: 16)),
                                    SizedBox(
                                      width: 36,
                                    ),
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 36,
                                    ),
                                  ])),
                          key: ValueKey(location.id),
                          child: LocationTile(location: location),
                          onDismissed: (direction) {},
                        ))
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

  _showConfirmDeleteDialog(BuildContext context, String name) {
    AlertDialog alert = AlertDialog(
      title: Text("Confirm delete"),
      content: Text("Are you sure you want to permanently delete $name?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("Delete"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
