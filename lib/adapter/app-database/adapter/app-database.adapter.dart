import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabaseAdapter {
  static final AppDatabaseAdapter _instance = AppDatabaseAdapter._();

  Database _database;

  factory AppDatabaseAdapter() {
    return _instance;
  }

  AppDatabaseAdapter._();

  Future<Database> get database async => _database ?? await _openDatabase();

  Future<Database> _openDatabase() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final databasePath = p.join(appDirectory.path, "data.db");
    return await databaseFactoryIo.openDatabase(databasePath);
  }
}
