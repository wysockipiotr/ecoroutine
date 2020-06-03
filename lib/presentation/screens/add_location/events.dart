import 'package:ecoschedule/domain/city.dart';
import 'package:ecoschedule/domain/street.dart';
import 'package:equatable/equatable.dart';

abstract class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object> get props => [];
}

class CitySelectedEvent extends AddLocationEvent {
  final City selectedCity;

  const CitySelectedEvent({this.selectedCity}) : super();

  @override
  List<Object> get props => [selectedCity];
}

class StreetSelectedEvent extends AddLocationEvent {
  final StreetIds selectedStreetIds;
  final String selectedHouseNumber;

  const StreetSelectedEvent({this.selectedStreetIds, this.selectedHouseNumber});

  @override
  List<Object> get props => [selectedStreetIds, selectedHouseNumber];
}
