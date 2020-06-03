import 'package:bloc/bloc.dart';
import 'package:ecoschedule/data/services/location.dart';
import 'package:ecoschedule/domain/street.dart';
import 'package:ecoschedule/presentation/screens/add_location/events.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  @override
  AddLocationState get initialState => SelectCityState();

  @override
  Stream<AddLocationState> mapEventToState(AddLocationEvent event) async* {
    if (event is CitySelectedEvent) {
      yield SelectStreetState(selectedCity: event.selectedCity);
    }

    if (event is StreetSelectedEvent) {
      yield* _mapStreetSelectedToState(event);
    }
  }

  Stream<AddLocationState> _mapStreetSelectedToState(
      StreetSelectedEvent event) async* {
    if (state is SelectStreetState) {
      print("I'm here");
      final selectedCity = (state as SelectStreetState).selectedCity;
      final schedulePeriodId =
          await getSchedulePeriods(cityId: selectedCity.id);

      List<Street> data = await getStreets(
          schedulePeriodId: schedulePeriodId.id,
          streetIds: event.selectedStreetIds.ids,
          houseNumber: event.selectedHouseNumber,
          cityId: selectedCity.id);

      if (data.isEmpty) {
      } else if (data.length == 1) {
        yield NameLocationState(
            houseNumber: event.selectedHouseNumber, streetId: data.first.id);
      } else {
        yield SpecifyAddressDetailsState(selectedStreetIds: "...");
      }
    }
  }
}
