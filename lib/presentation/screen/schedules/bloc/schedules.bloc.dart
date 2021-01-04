import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/domain/location/entity/entity.dart';
import 'package:ecoroutine/presentation/screen/locations/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/bloc.dart';

class SchedulesCubit extends Cubit<SchedulesState> {
  final LocationListCubit locationListBloc;
  StreamSubscription _locationBlocSubscription;

  SchedulesCubit(this.locationListBloc) : super(SchedulesReady({})) {
    _locationBlocSubscription = locationListBloc
        .where((state) => state is LocationListReady)
        .cast<LocationListReady>()
        .distinct((prev, next) {
      return prev == next;
    }).listen((LocationListState locationListState) {
      if (locationListState is LocationListReady) {
        onSchedulesRequested();
      }
    });
  }

  Future<void> onSchedulesRequested() async {
    if (locationListBloc.state is LocationListReady) {
      final locations = (locationListBloc.state as LocationListReady).locations;
      emit(SchedulesLoading());

      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals = {};
      for (final location in locations) {
        final streetId = await resolveCurrentStreetId(location: location);
        final disposals = await getSchedule(
            streetId: streetId, houseNumber: location.houseNumber);
        locationsToDisposals[location] = disposals;
      }

      emit(SchedulesReady(locationsToDisposals));
    }
  }

  Future<void> onRefreshRequested() async {
    if (locationListBloc.state is LocationListReady) {
      final locations = (locationListBloc.state as LocationListReady).locations;

      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals = {};
      for (final location in locations) {
        final streetId = await resolveCurrentStreetId(location: location);
        final disposals = await getSchedule(
            streetId: streetId, houseNumber: location.houseNumber);
        locationsToDisposals[location] = disposals;
      }

      emit(SchedulesReady(locationsToDisposals));
    }
  }

  @override
  Future<void> close() {
    _locationBlocSubscription?.cancel();
    return super.close();
  }
}
