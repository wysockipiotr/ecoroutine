import 'dart:async';

import 'package:ecoroutine/domain/location/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef EditDismissCallback = FutureOr<bool> Function();
typedef DeleteDismissCallback = FutureOr<bool> Function();

class LocationTile extends StatelessWidget {
  final LocationEntity location;
  final VoidCallback onTap;
  final EditDismissCallback onEdit;
  final DeleteDismissCallback onDelete;

  const LocationTile(
      {Key key, this.location, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async =>
          (direction == DismissDirection.endToStart) ? onDelete() : onEdit(),
      background: Container(
        color: Colors.grey[500],
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const SizedBox(
            width: 36,
          ),
          const Icon(Icons.edit, color: Colors.white),
          const SizedBox(
            width: 36,
          ),
          Text("Edit",
              style: GoogleFonts.monda(fontSize: 16, color: Colors.white))
        ]),
      ),
      secondaryBackground: Container(
          color: Colors.red[300],
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text("Delete",
                style: GoogleFonts.monda(fontSize: 16, color: Colors.white)),
            const SizedBox(
              width: 36,
            ),
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(
              width: 36,
            ),
          ])),
      key: ValueKey(location.id),
      child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
          )),
      onDismissed: (direction) {},
    );
  }
}
