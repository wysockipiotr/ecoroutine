import 'package:flutter/material.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  List<Step> steps = [
    Step(
        title: Text("Address"),
        isActive: true,
        state: StepState.editing,
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(filled: true, labelText: "City"),
            ),
            TextFormField(
              decoration: InputDecoration(filled: true, labelText: "Street"),
            ),
            TextFormField(
              decoration:
                  InputDecoration(filled: true, labelText: "House number"),
            ),
          ],
        )),
    Step(
        title: Text("Notifications"),
        isActive: false,
        state: StepState.disabled,
        content: Column(
          children: <Widget>[],
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add location"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[Expanded(child: Stepper(steps: steps))],
      ),
    );
  }
}
