import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:equatable/equatable.dart';

class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object> get props => [];
}

class TownSelectedEvent extends AddLocationEvent {
  final TownDto town;

  const TownSelectedEvent(this.town);

  @override
  List<Object> get props => [town];
}

class StreetSelectedEvent extends AddLocationEvent {
  final StreetIdsQueryResultDto streetIds;
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
