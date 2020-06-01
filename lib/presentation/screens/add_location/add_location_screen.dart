import 'package:ecoschedule/presentation/screens/add_location/address_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/city_step.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddLocationBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          title: Text("Add location"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Expanded(child: Builder(builder: (ctx) {
            return BlocBuilder<AddLocationBloc, AddLocationState>(
                builder: (BuildContext context, AddLocationState state) {
              List<Step> steps = [
                Step(
                    title: Text("City"),
                    isActive: state.stepIndex == 0,
                    state: (state.stepIndex >= 1)
                        ? StepState.complete
                        : StepState.indexed,
                    content: CityStep()),
                Step(
                    title: Text("Address"),
                    isActive: state.stepIndex == 1,
                    state: (state.stepIndex >= 2)
                        ? StepState.complete
                        : StepState.indexed,
                    content: AddressStep()),
                Step(
                    title: Text("Summary"),
                    // subtitle: Text("Work in progress..."),
                    // isActive: false,
                    state: StepState.disabled,
                    content: Column(
                      children: <Widget>[],
                    )),
              ];

              return Stepper(
                steps: steps,
                currentStep: state.stepIndex,
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
              );
            });
          })),
        ),
      ),
    );
  }
}
