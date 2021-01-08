import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/ecoharmonogram-api.dart'
    show getSchedule, resolveCurrentStreetId, WasteDisposalDto;
import 'package:ecoroutine/domain/location/location.dart'
    show LocationRepository, ILocationRepository, LocationEntity;
import 'package:equatable/equatable.dart';

class SchedulesState extends Equatable {
  const SchedulesState();

  @override
  List<Object> get props => [];
}

class NoLocations extends SchedulesState {}

class SchedulesError extends SchedulesState {}

class SchedulesLoading extends SchedulesState {}

class SchedulesReady extends SchedulesState {
  final LinkedHashMap<LocationEntity, List<WasteDisposalDto>>
      locationsToDisposals;

  const SchedulesReady(this.locationsToDisposals);

  @override
  List<Object> get props => [locationsToDisposals];
}

class SchedulesCubit extends Cubit<SchedulesState> {
  final ILocationRepository locationRepository;

  SchedulesCubit()
      : locationRepository = LocationRepository(),
        super(SchedulesLoading());

  addLocation(LocationEntity location) async {
    await locationRepository.add(location);
    await reload();
  }

  editLocation(LocationEntity location) async {
    await locationRepository.update(location);
    await reload();
  }

  deleteLocation(LocationEntity location) async {
    await locationRepository.delete(location.id);
    await reload();
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
