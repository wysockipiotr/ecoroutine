import 'package:ecoschedule/domain/location/entity/entity.dart';
import 'package:equatable/equatable.dart';

class LocationListState extends Equatable {
  const LocationListState();

  @override
  List<Object> get props => [];
}

class LocationListLoading extends LocationListState {}

class LocationListReady extends LocationListState {
  final List<LocationEntity> locations;

  const LocationListReady({this.locations});

  @override
  List<Object> get props => [locations];
}
