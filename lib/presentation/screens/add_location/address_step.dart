import 'package:ecoschedule/domain/city.dart';
import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressStep extends StatefulWidget {
  final City city;

  const AddressStep({Key key, this.city}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (BuildContext context, AddLocationState state) {
      if (state is SelectStreetState) {
        return Text("${state.selectedCity.name} is the city");
      }
      return null;
    });
  }
}
