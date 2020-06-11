import 'package:ecoschedule/domain/street_query_result.dart';
import 'package:ecoschedule/domain/town.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_step.dart';
import 'package:equatable/equatable.dart';

class AddLocationState extends Equatable {
  final AddLocationStep currentStep;
  final Town selectedTown;
  final String streetName;
  final List<StreetQueryResult> streetCandidates;
  final String selectedHouseNumber;
  final String sides;
  final String group;
  final String locationName;

  const AddLocationState(
      {this.currentStep,
      this.selectedTown,
      this.streetName,
      this.streetCandidates,
      this.selectedHouseNumber,
      this.sides,
      this.group,
      this.locationName});

  @override
  List<Object> get props => [
        currentStep,
        selectedTown,
        streetName,
        streetCandidates,
        selectedHouseNumber,
        sides,
        group,
        locationName
      ];

  @override
  String toString() => "AddLocationState { $currentStep }";

  AddLocationState copyWith(
          {AddLocationStep currentStep,
          Town selectedTown,
          String streetName,
          List<StreetQueryResult> streetCandidates,
          String selectedHouseNumber,
          String sides,
          String group,
          String locationName}) =>
      AddLocationState(
          currentStep: currentStep ?? this.currentStep,
          selectedTown: selectedTown ?? this.selectedTown,
          streetName: streetName ?? this.streetName,
          streetCandidates: streetCandidates ?? this.streetCandidates,
          selectedHouseNumber: selectedHouseNumber ?? this.selectedHouseNumber,
          sides: sides ?? this.sides,
          group: group ?? this.group,
          locationName: locationName ?? this.locationName);
}
