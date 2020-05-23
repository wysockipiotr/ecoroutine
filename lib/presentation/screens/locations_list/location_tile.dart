import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final String name;
  final String address;

  const LocationTile({this.name, this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.home),
            SizedBox(
              width: 24.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(name), Text(address)],
            )
          ],
        ),
      ),
    );
  }
}
