import 'package:ecoroutine/bloc/bloc.dart';
import 'package:ecoroutine/domain/location/entity/entity.dart';
import 'package:ecoroutine/presentation/screen/add_location/add-location.screen.dart';
import 'package:ecoroutine/presentation/screen/locations/widget/widget.dart';
import 'package:ecoroutine/presentation/screen/schedules/schedules.screen.dart';
import 'package:ecoroutine/utility/utility.dart' show MapIndexed;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationsScreen extends StatefulWidget {
  static const RouteName = "/locations";

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Locations", style: GoogleFonts.monda()),
        ),
        body: _buildLocationsList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, AddLocationScreen.RouteName);
          },
        ),
      );

  Widget _buildLocationsList() {
    return BlocBuilder<SchedulesCubit, SchedulesState>(
      builder: (context, state) {
        if (state is SchedulesReady) {
          return ListView(
            children: state.locationsToDisposals.keys
                .toList()
                .mapIndexed((int index, LocationEntity location) {
              return LocationTile(
                  location: location,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SchedulesScreen.RouteName, (route) => false,
                        arguments: index);
                  },
                  onEdit: () async {
                    final updatedName =
                        await _showEditDialog(context, location.name);
                    if (updatedName == null) {
                      return false;
                    } else {
                      context
                          .read<SchedulesCubit>()
                          .editLocation(location.copyWith(name: updatedName));
                      return false;
                    }
                  },
                  onDelete: () async {
                    final deletionConfirmed = await _showConfirmDeleteDialog(
                            context, location.name) ??
                        false;
                    if (deletionConfirmed) {
                      context.read<SchedulesCubit>().deleteLocation(location);
                    }
                    return deletionConfirmed;
                  });
            }).toList(),
          );
        } else if (state is NoLocations) {
          return Center(child: const Text("No locations"));
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  _showConfirmDeleteDialog(BuildContext context, String name) {
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm delete"),
      content: Text("Are you sure you want to permanently delete $name?"),
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: const Text("Delete"),
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
      title: const Text("Rename"),
      content: TextFormField(
        autofocus: true,
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        decoration:
            const InputDecoration(filled: true, labelText: "Location name"),
        onFieldSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: const Text("Save"),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
