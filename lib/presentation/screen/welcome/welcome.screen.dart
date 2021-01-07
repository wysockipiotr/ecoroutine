import 'package:ecoroutine/presentation/screen/screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: FlatButton(
            child: Text("Add first location"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocationsScreen()));
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddLocationScreen()));
            },
          ),
        ),
      ),
    );
  }
}
