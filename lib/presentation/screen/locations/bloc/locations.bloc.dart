import 'package:bloc/bloc.dart';
import 'package:ecoschedule/domain/location/repository/repository.dart';
import 'package:ecoschedule/presentation/screen/locations/bloc/bloc.dart';

class LocationListBloc extends Bloc<LocationListEvent, LocationListState> {
  final ILocationRepository _locationRepository;

  LocationListBloc() : _locationRepository = LocationRepository();

  @override
  LocationListState get initialState => LocationListReady(locations: []);

  @override
  Stream<LocationListState> mapEventToState(LocationListEvent event) async* {
    if (event == LocationListEvent.ReloadLocations) {
      yield LocationListLoading();
      final locations = await _locationRepository.getAll();
      yield LocationListReady(locations: locations);
    }
  }
}
