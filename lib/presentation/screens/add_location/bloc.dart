import 'package:bloc/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/events.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  @override
  AddLocationState get initialState => SelectCityState();

  @override
  Stream<AddLocationState> mapEventToState(AddLocationEvent event) async* {
    if (event is CitySelectedEvent) {
      yield SelectStreetState(selectedCity: event.selectedCity);
    }
  }
}
