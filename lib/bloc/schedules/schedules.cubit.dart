import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/ecoharmonogram-api.dart'
    show getSchedule, resolveCurrentStreetId, WasteDisposalDto;
import 'package:ecoroutine/bloc/schedules/schedules.dart';
import 'package:ecoroutine/domain/location/location.dart'
    show LocationRepository, ILocationRepository, LocationEntity;

class SchedulesCubit extends Cubit<SchedulesState> {
  final ILocationRepository locationRepository;

  SchedulesCubit()
      : locationRepository = LocationRepository(),
        super(SchedulesLoading());

  addLocation(LocationEntity location) async {
    await locationRepository.add(location);
    await reload();
  }

  editLocation(LocationEntity updatedLocation) async {
    if (state is SchedulesReady) {
      final locationsToDisposals =
          (state as SchedulesReady).locationsToDisposals;
      emit(SchedulesLoading());
      await locationRepository.update(updatedLocation);
      final updatedLocationsToDisposals = LinkedHashMap.fromEntries(
          locationsToDisposals.entries.map((locationToDisposal) {
        if (locationToDisposal.key.id == updatedLocation.id) {
          return MapEntry(updatedLocation, locationToDisposal.value);
        }
        return locationToDisposal;
      }));
      emit(SchedulesReady(updatedLocationsToDisposals));
    }
  }

  deleteLocation(LocationEntity deletedLocation) async {
    if (state is SchedulesReady) {
      final locationsToDisposals =
          (state as SchedulesReady).locationsToDisposals;
      emit(SchedulesLoading());
      await locationRepository.delete(deletedLocation.id);
      final updatedLocationsToDisposals = LinkedHashMap.fromEntries(
          locationsToDisposals.entries.where((locationToDisposal) =>
              locationToDisposal.key.id != deletedLocation.id));
      if (updatedLocationsToDisposals.isEmpty) {
        emit(NoLocations());
      } else {
        emit(SchedulesReady(updatedLocationsToDisposals));
      }
    }
  }

  refresh() async {
    final locations = await locationRepository.getAll();
    if (locations.isEmpty) {
      emit(NoLocations());
    }
    try {
      final locationsToDisposals = LinkedHashMap.fromIterables(
        locations,
        await Future.wait(
            locations.map((location) => _getSchedulesForLocation(location)),
            eagerError: true),
      );
      emit(SchedulesReady(locationsToDisposals));
    } on SocketException catch (error) {
      print(error);
      emit(SchedulesError());
    }
  }

  reload() async {
    emit(SchedulesLoading());
    await refresh();
  }

  Future<List<WasteDisposalDto>> _getSchedulesForLocation(
      LocationEntity location) async {
    try {
      final streetId = await resolveCurrentStreetId(location: location);
      return await getSchedule(
          streetId: streetId, houseNumber: location.houseNumber);
    } on SocketException catch (error) {
      return Future.error(error);
    }
  }
}
