import 'package:ecoschedule/data/persistence/database.dart';
import 'package:ecoschedule/domain/location.dart';
import 'package:sembast/sembast.dart';

class LocationDao {
  static const String LOCATION_STORE_NAME = "location_store";

  final _locationStore = intMapStoreFactory.store(LOCATION_STORE_NAME);

  Future<Database> get _db async => await AppDatabase().database;

  Future<Location> add(Location location) async {
    final id = await _locationStore.add(await _db, location.toMap());
    return location.copyWith(id: id);
  }

  Future<Location> update(Location location) async {
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationStore.update(await _db, location.toMap(), finder: finder);
    return location;
  }

  Future<void> delete(int id) async {
    await _locationStore.delete(await _db,
        finder: Finder(filter: Filter.byKey(id)));
  }

  Future<List<Location>> getAll() async {
    final snapshot = await _locationStore.find(await _db);
    return snapshot
        .map((snapshot) =>
            Location.fromMap(snapshot.value).copyWith(id: snapshot.key))
        .toList();
  }
}
