import 'package:ecoschedule/domain/city.dart';
import 'package:equatable/equatable.dart';

abstract class AddLocationState extends Equatable {
  const AddLocationState();

  @override
  List<Object> get props => [];

  int get stepIndex;
}

class SelectCityState extends AddLocationState {
  @override
  int get stepIndex => 0;
}

class SelectStreetState extends AddLocationState {
  final City selectedCity;

  const SelectStreetState({this.selectedCity});

  @override
  List<Object> get props => [selectedCity];

  @override
  int get stepIndex => 1;
}

class SpecifyAddressDetailsState extends AddLocationState {
  final String selectedStreetIds;

  const SpecifyAddressDetailsState({this.selectedStreetIds});

  @override
  List<Object> get props => [selectedStreetIds];

  @override
  int get stepIndex => 2;
}

class NameLocationState extends AddLocationState {
  final String streetId;
  final String houseNumber;

  const NameLocationState({this.streetId, this.houseNumber});

  @override
  List<Object> get props => [streetId, houseNumber];

  @override
  int get stepIndex => 4;
}
