import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/redacteur.dart';


class DatabaseManager {
  Database? _database;

  Future<Database> initDatabase() async {
    if (_database != null) {
      return _database!;
    }
    String path = await getDatabasesPath();
    String fullPath = join(path, 'redacteurs.db');

    _database = await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE redacteurs ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nom TEXT, '
          'prenom TEXT, '
          'email TEXT'
          ')',
        );
      },
    );
    return _database!;
  }
  Future<int> insertRedacteur() async {
    final db = awqit initDatabase();
    return await db.insert(
      'redacteurs',
      redacteur.toMap(),
    );
  }
}
