import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SaveLocationStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SaveLocationStepState();
}

class _SaveLocationStepState extends State<SaveLocationStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: "Location name", filled: true),
        ),
        Spacer(),
        RaisedButton(
          child: Text("Save"),
          onPressed: () {},
        )
      ],
    );
  }
}
