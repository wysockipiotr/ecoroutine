import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoschedule/presentation/screen/add_location/enum/enum.dart';
import 'package:equatable/equatable.dart';

class AddLocationState extends Equatable {
  final AddLocationStep currentStep;
  final TownDto selectedTown;
  final String streetName;
  final List<StreetQueryResultDto> streetCandidates;
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
          TownDto selectedTown,
          String streetName,
          List<StreetQueryResultDto> streetCandidates,
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
