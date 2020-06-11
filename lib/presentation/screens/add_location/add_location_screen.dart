import 'package:ecoschedule/presentation/screens/add_location/address_details_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/address_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/city_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/name_location_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddLocationBloc(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            title: const Text("Add location"),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<AddLocationBloc, AddLocationState>(
                    builder: (BuildContext context, AddLocationState state) =>
                        _buildStepper(state)),
              )
            ],
          ),
        ));
  }

  List<Step> _buildSteps(AddLocationState state) {
    StepState addressDetailsStepState = StepState.disabled;
    if (state.stepIndex == 2) {
      addressDetailsStepState = StepState.indexed;
    } else if (state.stepIndex > 2) {
      addressDetailsStepState = StepState.complete;
    }

    return [
      Step(
          title: const Text("City"),
          subtitle:
              state is SelectStreetState ? Text(state.selectedCity.name) : null,
          isActive: state.stepIndex == 0,
          state:
              (state.stepIndex >= 1) ? StepState.complete : StepState.indexed,
          content: CityStep()),
      Step(
          title: const Text("Address"),
          isActive: state.stepIndex == 1,
          state:
              (state.stepIndex >= 2) ? StepState.complete : StepState.indexed,
          content: AddressStep()),
      Step(
          title: const Text("Address details"),
          subtitle: (state.stepIndex >= 2)
              ? null
              : const Text("Not required for this address"),
          isActive: state.stepIndex == 2,
          state: addressDetailsStepState,
          content: AddressDetailsStep()),
      Step(
          title: const Text("Location name"),
          state:
              (state.stepIndex >= 3) ? StepState.complete : StepState.indexed,
          isActive: state.stepIndex == 3,
          content: NameLocationStep()),
    ];
  }

  Stepper _buildStepper(AddLocationState state) {
    return Stepper(
      steps: _buildSteps(state),
      currentStep: state.stepIndex,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      },
    );
  }
}
