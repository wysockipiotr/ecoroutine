import 'package:bloc/bloc.dart';
import 'package:ecoschedule/data/persistence/dao.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:equatable/equatable.dart';

enum LocationListEvent { ReloadLocations }

class LocationListState extends Equatable {
  const LocationListState();

  @override
  List<Object> get props => [];
}

class LocationListLoading extends LocationListState {}

class LocationListReady extends LocationListState {
  final List<Location> locations;

  const LocationListReady({this.locations});

  @override
  List<Object> get props => [locations];
}

class LocationListBloc extends Bloc<LocationListEvent, LocationListState> {
  final LocationDao _locationDao;

  LocationListBloc() : _locationDao = LocationDao();

  @override
  LocationListState get initialState => LocationListReady(locations: []);

  @override
  Stream<LocationListState> mapEventToState(LocationListEvent event) async* {
    if (event == LocationListEvent.ReloadLocations) {
      yield LocationListLoading();
      final locations = await _locationDao.getAll();
      yield LocationListReady(locations: locations);
    }
  }
}
