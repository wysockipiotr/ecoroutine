import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/waste-disposal.dto.dart';
import 'package:ecoschedule/domain/location/entity/entity.dart';
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
  final Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals;

  const SchedulesReady(this.locationsToDisposals);

  @override
  List<Object> get props => [locationsToDisposals];
}
