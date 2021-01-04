import 'package:ecoroutine/adapter/app-database/app-database.dart'
    show AppDatabaseAdapter;
import 'package:ecoroutine/domain/location/entity/entity.dart'
    show LocationEntity;
import 'package:ecoroutine/domain/location/repository/repository.dart'
    show ILocationRepository;
import 'package:sembast/sembast.dart';

class LocationRepository implements ILocationRepository {
  static const String LOCATION_STORE_NAME = "location_store";

  final _locationStore = intMapStoreFactory.store(LOCATION_STORE_NAME);

  Future<Database> get _db async => await AppDatabaseAdapter().database;

  @override
  Future<LocationEntity> add(LocationEntity location) async {
    final id = await _locationStore.add(await _db, location.toMap());
    return location.copyWith(id: id);
  }

  @override
  Future<LocationEntity> update(LocationEntity location) async {
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationStore.update(await _db, location.toMap(), finder: finder);
    return location;
  }

  @override
  Future<void> delete(int id) async {
    await _locationStore.delete(await _db,
        finder: Finder(filter: Filter.byKey(id)));
  }

  @override
  Future<List<LocationEntity>> getAll() async {
    final snapshot = await _locationStore.find(await _db);
    return snapshot
        .map((snapshot) =>
            LocationEntity.fromMap(snapshot.value).copyWith(id: snapshot.key))
        .toList();
  }
}
