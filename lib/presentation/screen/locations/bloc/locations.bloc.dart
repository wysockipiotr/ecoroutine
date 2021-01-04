import 'package:bloc/bloc.dart';
import 'package:ecoroutine/domain/location/repository/repository.dart';
import 'package:ecoroutine/presentation/screen/locations/bloc/bloc.dart';

class LocationListCubit extends Cubit<LocationListState> {
  final ILocationRepository _locationRepository;

  LocationListCubit()
      : _locationRepository = LocationRepository(),
        super(LocationListReady(locations: []));

  Future<void> reloadLocations() async {
    emit(LocationListLoading());
    emit(LocationListReady(locations: await _locationRepository.getAll()));
  }
}
