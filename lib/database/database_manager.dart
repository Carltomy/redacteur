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
      onCreate: (db, version) async {
        await db.execute(
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

  //  AJOUTER
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await initDatabase();
    return await db.insert('redacteurs', redacteur.toMap());
  }

  // AFFICHER
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> maps = await db.query('redacteurs');

    return List.generate(maps.length, (i) {
      return Redacteur.fromMap(
        maps[i]['id'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['email'],
      );
    });
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await initDatabase();
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await initDatabase();
    return await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
