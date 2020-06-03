import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameLocationStep extends StatefulWidget {
  @override
  _NameLocationStepState createState() => _NameLocationStepState();
}

class _NameLocationStepState extends State<NameLocationStep> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (context, state) {
      if (state is NameLocationState) {
        return Text("${state.streetId}, ${state.houseNumber}");
      } else {
        return null;
      }
    });
  }
}
