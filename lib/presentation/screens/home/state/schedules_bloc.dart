import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecoschedule/data/services/api/schedules.dart';
import 'package:ecoschedule/data/services/api/street.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:ecoschedule/domain/waste_disposal.dart';
import 'package:ecoschedule/presentation/screens/locations_list/state/location_list_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SchedulesState extends Equatable {
  const SchedulesState();

  @override
  List<Object> get props => [];
}

class SchedulesLoading extends SchedulesState {
  const SchedulesLoading();
}

class SchedulesReady extends SchedulesState {
  final Map<Location, List<WasteDisposal>> locationsToDisposals;

  const SchedulesReady(this.locationsToDisposals);

  @override
  List<Object> get props => [locationsToDisposals];
}

enum SchedulesEvent { SchedulesRequested, RefreshRequested }

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

      Map<Location, List<WasteDisposal>> locationsToDisposals = {};
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

      Map<Location, List<WasteDisposal>> locationsToDisposals = {};
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
