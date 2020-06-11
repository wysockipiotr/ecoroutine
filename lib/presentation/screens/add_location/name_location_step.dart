import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameLocationStep extends StatefulWidget {
  @override
  _NameLocationStepState createState() => _NameLocationStepState();
}

class _NameLocationStepState extends State<NameLocationStep> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (context, state) {
      if (state is NameLocationState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.home),
                  filled: true),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton.icon(
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("Saving location...",
                        style: TextStyle(color: Theme.of(context).accentColor)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ));
                },
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.save_alt),
                label: Text("Save"))
          ],
        );
      } else {
        return Container(
          height: 0.0,
        );
      }
    });
  }
}
