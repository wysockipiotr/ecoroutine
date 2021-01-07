import 'package:ecoroutine/domain/location/repository/repository.dart';
import 'package:ecoroutine/presentation/screen/locations/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/locations/widget/widget.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/page.bloc.dart';
import 'package:ecoroutine/presentation/screen/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  void initState() {
    context.read<LocationListCubit>().reloadLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locationDao = LocationRepository();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Locations", style: GoogleFonts.monda()),
      ),
      body: BlocBuilder<LocationListCubit, LocationListState>(
        builder: (context, state) {
          if (state is LocationListReady) {
            return ListView(
              children: state.locations
                  .asMap()
                  .entries
                  .map((location) => Dismissible(
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            final deletionConfirmed =
                                await _showConfirmDeleteDialog(
                                        context, location.value.name) ??
                                    false;
                            if (deletionConfirmed) {
                              await locationDao.delete(location.value.id);
                              context
                                  .read<LocationListCubit>()
                                  .reloadLocations();
                            }
                            return deletionConfirmed;
                          } else {
                            final updatedName = await _showEditDialog(
                                context, location.value.name);
                            if (updatedName == null) {
                              return false;
                            } else {
                              await locationDao.update(
                                  location.value.copyWith(name: updatedName));
                              context
                                  .read<LocationListCubit>()
                                  .reloadLocations();
                              return false;
                            }
                          }
                        },
                        background: Container(
                          color: Colors.grey[500],
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 36,
                                ),
                                Icon(Icons.edit, color: Colors.white),
                                SizedBox(
                                  width: 36,
                                ),
                                Text("Edit",
                                    style: GoogleFonts.monda(
                                        fontSize: 16, color: Colors.white))
                              ]),
                        ),
                        secondaryBackground: Container(
                            color: Colors.red[300],
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text("Delete",
                                      style: GoogleFonts.monda(
                                          fontSize: 16, color: Colors.white)),
                                  SizedBox(
                                    width: 36,
                                  ),
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(
                                    width: 36,
                                  ),
                                ])),
                        key: ValueKey(location.value.id),
                        child: LocationTile(
                          location: location.value,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.read<PageCubit>().switchPage(location.key);
                          },
                        ),
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
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddLocationScreen()));
          context.read<LocationListCubit>().reloadLocations();
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
