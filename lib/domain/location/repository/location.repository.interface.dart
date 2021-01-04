import 'package:ecoroutine/domain/location/entity/entity.dart';

abstract class ILocationRepository {
  Future<LocationEntity> add(LocationEntity location);
  Future<LocationEntity> update(LocationEntity location);
  Future<void> delete(int id);
  Future<List<LocationEntity>> getAll();
}
