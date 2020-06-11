import 'package:ecoschedule/presentation/screens/add_location/address_details_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/address_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/name_location_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_state.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/town_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

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
    if (state.currentStep == AddLocationStep.SelectDetails) {
      addressDetailsStepState = StepState.indexed;
    } else if (state.currentStep.index > AddLocationStep.SelectDetails.index) {
      if (state.sides != null || state.group != null) {
        addressDetailsStepState = StepState.complete;
      }
    }

    String detailsStepSubtitle = "Not required for this address";
    if (state.currentStep == AddLocationStep.SelectDetails) {
      detailsStepSubtitle = "";
    }
    if (state.currentStep.index > AddLocationStep.SelectDetails.index) {
      final subtitleParts = [
        if (state.sides != null) state.sides.titleCase,
        if (state.group != null) state.group
      ];

      if (subtitleParts.isNotEmpty) {
        detailsStepSubtitle = subtitleParts.join(", ");
      }
    }

    String townStepSubtitle = "";
    if (state.selectedTown != null) {
      final subtitleParts = [
        state.selectedTown.name,
        if (state.selectedTown.name != state.selectedTown.district)
          state.selectedTown.district,
        state.selectedTown.province
      ];
      townStepSubtitle = subtitleParts.join(", ");
    }

    return [
      Step(
          title: const Text("Town"),
          subtitle: Text(townStepSubtitle),
          isActive: state.currentStep == AddLocationStep.SelectTown,
          state: (state.currentStep.index > AddLocationStep.SelectTown.index)
              ? StepState.complete
              : StepState.indexed,
          content: TownStep()),
      Step(
          title: const Text("Address"),
          subtitle:
              state.streetName != null && state.selectedHouseNumber != null
                  ? Text("${state.streetName} ${state.selectedHouseNumber}")
                  : null,
          isActive: state.currentStep == AddLocationStep.EnterAddress,
          state: (state.currentStep.index > AddLocationStep.EnterAddress.index)
              ? StepState.complete
              : StepState.indexed,
          content: AddressStep()),
      Step(
          title: const Text("Details"),
          subtitle: Text(detailsStepSubtitle),
          isActive: state.currentStep == AddLocationStep.SelectDetails,
          state: addressDetailsStepState,
          content: AddressDetailsStep()),
      Step(
          title: const Text("Name"),
          state: (state.currentStep.index > AddLocationStep.NameLocation.index)
              ? StepState.complete
              : StepState.indexed,
          isActive: state.currentStep == AddLocationStep.NameLocation,
          content: NameLocationStep()),
    ];
  }

  Stepper _buildStepper(AddLocationState state) {
    return Stepper(
      steps: _buildSteps(state),
      currentStep: state.currentStep.index,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      },
    );
  }
}
