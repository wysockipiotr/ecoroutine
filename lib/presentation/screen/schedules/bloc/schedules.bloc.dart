import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecoschedule/adapter/adapter.dart';
import 'package:ecoschedule/domain/location/entity/entity.dart';
import 'package:ecoschedule/presentation/screen/locations/bloc/bloc.dart';
import 'package:ecoschedule/presentation/screen/schedules/bloc/bloc.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  final LocationListBloc locationListBloc;
  StreamSubscription _locationBlocSubscription;

  SchedulesBloc(this.locationListBloc) {
    _locationBlocSubscription = locationListBloc
        .where((state) => state is LocationListReady)
        .cast<LocationListReady>()
        .distinct((prev, next) {
      return prev == next;
    }).listen((LocationListState locationListState) {
      if (locationListState is LocationListReady) {
        add(SchedulesEvent.SchedulesRequested);
      }
    });
  }

  @override
  SchedulesState get initialState => SchedulesReady({});

  @override
  Stream<SchedulesState> mapEventToState(SchedulesEvent event) async* {
    if (locationListBloc.state is LocationListReady &&
        event == SchedulesEvent.SchedulesRequested) {
      final locations = (locationListBloc.state as LocationListReady).locations;
      yield SchedulesLoading();

      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals = {};
      for (final location in locations) {
        final streetId = await resolveCurrentStreetId(location: location);
        final disposals = await getSchedule(
            streetId: streetId, houseNumber: location.houseNumber);
        locationsToDisposals[location] = disposals;
      }

      yield SchedulesReady(locationsToDisposals);
    } else if (event == SchedulesEvent.RefreshRequested &&
        locationListBloc.state is LocationListReady) {
      final locations = (locationListBloc.state as LocationListReady).locations;

      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals = {};
      for (final location in locations) {
        final streetId = await resolveCurrentStreetId(location: location);
        final disposals = await getSchedule(
            streetId: streetId, houseNumber: location.houseNumber);
        locationsToDisposals[location] = disposals;
      }

      yield SchedulesReady(locationsToDisposals);
    }
  }

  @override
  Future<void> close() {
    _locationBlocSubscription?.cancel();
    return super.close();
  }
}
