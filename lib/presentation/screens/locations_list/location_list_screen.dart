import 'package:ecoschedule/data/persistence/dao.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:ecoschedule/presentation/screens/add_location/add_location_screen.dart';
import 'package:ecoschedule/presentation/screens/locations_list/location_tile.dart';
import 'package:ecoschedule/presentation/screens/locations_list/state/location_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsListScreen extends StatefulWidget {
  @override
  _LocationsListScreenState createState() => _LocationsListScreenState();
}

class _LocationsListScreenState extends State<LocationsListScreen> {
  @override
  void initState() {
    BlocProvider.of<LocationListBloc>(context)
        .add(LocationListEvent.ReloadLocations);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locationDao = LocationDao();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text("Locations", style: GoogleFonts.monda()),
      ),
      body: BlocBuilder<LocationListBloc, LocationListState>(
        builder: (context, state) {
          if (state is LocationListReady) {
            return ListView(
              children: state.locations
                  .map((Location location) => Dismissible(
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            final deletionConfirmed =
                                await _showConfirmDeleteDialog(
                                        context, location.name) ??
                                    false;
                            if (deletionConfirmed) {
                              await locationDao.delete(location.id);

                              BlocProvider.of<LocationListBloc>(context)
                                  .add(LocationListEvent.ReloadLocations);
                            }
                            return deletionConfirmed;
                          } else {
                            final updatedName =
                                await _showEditDialog(context, location.name);
                            if (updatedName == null) {
                              return false;
                            } else {
                              await locationDao
                                  .update(location.copyWith(name: updatedName));
                              BlocProvider.of<LocationListBloc>(context)
                                  .add(LocationListEvent.ReloadLocations);
                              return false;
                            }
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddLocationScreen()));
          BlocProvider.of<LocationListBloc>(context)
              .add(LocationListEvent.ReloadLocations);
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

  _showEditDialog(BuildContext context, String name) {
    TextEditingController controller = TextEditingController(text: name);

    AlertDialog alert = AlertDialog(
      title: Text("Rename"),
      content: TextFormField(
        autofocus: true,
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(filled: true, labelText: "Location name"),
        onFieldSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
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
