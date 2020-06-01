import 'package:ecoschedule/domain/city.dart';
import 'package:equatable/equatable.dart';

abstract class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object> get props => [];
}

class CitySelectedEvent extends AddLocationEvent {
  final City selectedCity;

  const CitySelectedEvent({this.selectedCity}) : super();
}
