import 'package:ecoschedule/data/persistence/dao.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_state.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_step.dart';
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
      if (state.currentStep == AddLocationStep.NameLocation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextFormField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.home),
                  filled: true),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton.icon(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await LocationDao().add(Location(
                        name: _controller.text,
                        town: state.selectedTown,
                        streetName: state.streetName,
                        houseNumber: state.selectedHouseNumber,
                        sides: state.sides,
                        group: state.group));
                    Navigator.of(context).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                          "Location ${_controller.text} has been successfully saved",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  }
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
