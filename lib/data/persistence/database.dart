import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();

  AppDatabase._();

  Database _database;

  factory AppDatabase() {
    return _instance;
  }

  Future<Database> get database async => _database ?? await _openDatabase();

  Future<Database> _openDatabase() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final databasePath = p.join(appDirectory.path, "data.db");
    return await databaseFactoryIo.openDatabase(databasePath);
  }
}
