import 'package:bloc/bloc.dart';
import 'package:ecoschedule/adapter/ecoharmonogram-api/adapter/adapter.dart';
import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoschedule/presentation/screen/add_location/bloc/bloc.dart';
import 'package:ecoschedule/presentation/screen/add_location/enum/enum.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  @override
  AddLocationState get initialState =>
      AddLocationState(currentStep: AddLocationStep.SelectTown);

  AddLocationStep get currentStep => state.currentStep;

  @override
  Stream<AddLocationState> mapEventToState(AddLocationEvent event) async* {
    if (event is TownSelectedEvent) {
      yield state.copyWith(
          currentStep: AddLocationStep.EnterAddress, selectedTown: event.town);
    }

    if (event is StreetSelectedEvent) {
      final streetIds = event.streetIds;

      final SchedulePeriodDto schedulePeriod =
          await getSchedulePeriods(townId: state.selectedTown.id);

      final List<StreetQueryResultDto> streetCandidates = await getStreets(
          townId: state.selectedTown.id,
          schedulePeriodId: schedulePeriod.id,
          houseNumber: state.selectedHouseNumber,
          streetIds: streetIds.ids);

      if (streetCandidates.length == 0) {
        // TODO: Show error snackbar
      } else if (streetCandidates.length == 1) {
        yield state.copyWith(
            currentStep: AddLocationStep.NameLocation,
            streetName: event.streetIds.name,
            selectedHouseNumber: event.houseNumber);
      } else {
        final sidesCount =
            streetCandidates.map((candidate) => candidate.sides).toSet().length;
        final groupsCount =
            streetCandidates.map((candidate) => candidate.group).toSet().length;

        if (sidesCount > 1 || groupsCount > 1) {
          yield state.copyWith(
              currentStep: AddLocationStep.SelectDetails,
              streetCandidates: streetCandidates,
              streetName: event.streetIds.name,
              selectedHouseNumber: event.houseNumber);
        } else {
          // TODO: Check if selected house number is available

          yield state.copyWith(
              currentStep: AddLocationStep.NameLocation,
              streetName: event.streetIds.name,
              selectedHouseNumber: event.houseNumber);
        }
      }
    }

    if (event is DetailsSelectedEvent) {
      yield state.copyWith(
          currentStep: AddLocationStep.NameLocation,
          sides: event.sides,
          group: event.group);
    }
  }
}
