import 'dart:collection';

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
    if (event is DetailsSelectedEvent) {
      yield NameLocationState();
    }
  }

  Stream<AddLocationState> _mapStreetSelectedToState(
      StreetSelectedEvent event) async* {
    if (state is SelectStreetState) {
      final selectedCity = (state as SelectStreetState).selectedCity;
      final schedulePeriodId =
          await getSchedulePeriods(cityId: selectedCity.id);

      List<Street> streetVariants = await getStreets(
          schedulePeriodId: schedulePeriodId.id,
          streetIds: event.selectedStreetIds.ids,
          houseNumber: event.selectedHouseNumber,
          cityId: selectedCity.id);

      if (streetVariants.isEmpty) {
      } else if (streetVariants.length == 1) {
        yield NameLocationState(
            houseNumber: event.selectedHouseNumber,
            streetId: streetVariants.first.id);
      } else {
        final sidesVariants = SplayTreeSet<String>.from(
            streetVariants.map((street) => street.sides));
        final groupVariants = SplayTreeSet<String>.from(
            streetVariants.map((street) => street.group));

        if (sidesVariants.length == 1 && groupVariants.length == 1) {
          final street = streetVariants.firstWhere(
              (street) => street.numbers.contains(event.selectedHouseNumber));
          yield NameLocationState(
              houseNumber: event.selectedHouseNumber, streetId: street.id);
        }

        yield SpecifyAddressDetailsState(streetVariants: streetVariants);
      }
    }
  }
}
