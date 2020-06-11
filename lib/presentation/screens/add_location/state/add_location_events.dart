import 'package:ecoschedule/domain/street_query_result.dart';
import 'package:ecoschedule/domain/town.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_step.dart';
import 'package:equatable/equatable.dart';

class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object> get props => [];
}

class SaveLocationEvent extends AddLocationEvent {}

class TownSelectedEvent extends AddLocationEvent {
  final Town town;

  const TownSelectedEvent(this.town);

  @override
  List<Object> get props => [town];
}

class StreetSelectedEvent extends AddLocationEvent {
  final StreetIdsQueryResult streetIds;
  final String houseNumber;

  const StreetSelectedEvent(this.streetIds, this.houseNumber);

  @override
  List<Object> get props => [streetIds, houseNumber];
}

class DetailsSelectedEvent extends AddLocationEvent {
  final String sides;
  final String group;

  const DetailsSelectedEvent({this.sides, this.group});

  @override
  List<Object> get props => [sides, group];
}
