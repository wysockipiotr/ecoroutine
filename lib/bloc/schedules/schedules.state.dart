import 'dart:collection';

import 'package:ecoroutine/adapter/ecoharmonogram-api/ecoharmonogram-api.dart'
    show WasteDisposalDto;
import 'package:ecoroutine/domain/location/location.dart' show LocationEntity;
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
