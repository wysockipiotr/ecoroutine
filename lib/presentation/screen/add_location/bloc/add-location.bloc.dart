import 'package:bloc/bloc.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoroutine/presentation/screen/add_location/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/add_location/enum/enum.dart';

class AddLocationCubit extends Cubit<AddLocationState> {
  AddLocationCubit()
      : super(AddLocationState(currentStep: AddLocationStep.SelectTown));

  AddLocationStep get currentStep => state.currentStep;

  void onTownSelected({TownDto town}) => emit(state.copyWith(
      currentStep: AddLocationStep.EnterAddress, selectedTown: town));

  Future<void> onStreetSelected(
      {StreetIdsQueryResultDto streetIds, String houseNumber}) async {
    final SchedulePeriodDto schedulePeriod =
        await getSchedulePeriods(townId: state.selectedTown.id);

    final List<StreetQueryResultDto> streetCandidates = await getStreets(
        townId: state.selectedTown.id,
        schedulePeriodId: schedulePeriod.id,
        houseNumber: state.selectedHouseNumber,
        streetIds: streetIds.ids);

    if (streetCandidates.isEmpty) {
      _onNoStreetCandidates();
    } else if (streetCandidates.length == 1) {
      _onOneStreetCandidate(streetIds, houseNumber);
    } else {
      _onManyStreetCandidates(streetCandidates, streetIds, houseNumber);
    }
  }

  void onDetailsSelected({String sides, String group}) => emit(state.copyWith(
      currentStep: AddLocationStep.NameLocation, sides: sides, group: group));

  void _onNoStreetCandidates() {
    // TODO: Error
  }

  void _onOneStreetCandidate(
      StreetIdsQueryResultDto streetIds, String houseNumber) {
    emit(state.copyWith(
        currentStep: AddLocationStep.NameLocation,
        streetName: streetIds.name,
        selectedHouseNumber: houseNumber));
  }

  void _onManyStreetCandidates(List<StreetQueryResultDto> streetCandidates,
      StreetIdsQueryResultDto streetIds, String houseNumber) {
    final sidesCount =
        streetCandidates.map((candidate) => candidate.sides).toSet().length;
    final groupsCount =
        streetCandidates.map((candidate) => candidate.group).toSet().length;

    if (sidesCount > 1 || groupsCount > 1) {
      _onAmbiguousSidesOrGroups(streetCandidates, streetIds, houseNumber);
    } else {
      _onUnambiguousSidesAndGroup(streetIds, houseNumber);
    }
  }

  void _onAmbiguousSidesOrGroups(List<StreetQueryResultDto> streetCandidates,
      StreetIdsQueryResultDto streetIds, String houseNumber) {
    emit(state.copyWith(
        currentStep: AddLocationStep.SelectDetails,
        streetCandidates: streetCandidates,
        streetName: streetIds.name,
        selectedHouseNumber: houseNumber));
  }

  void _onUnambiguousSidesAndGroup(
      StreetIdsQueryResultDto streetIds, String houseNumber) {
    emit(state.copyWith(
        currentStep: AddLocationStep.NameLocation,
        streetName: streetIds.name,
        selectedHouseNumber: houseNumber));
  }
}
