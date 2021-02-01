import 'package:bibliography/models/biblio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  static const initScript = [
    '''
    CREATE TABLE "biblio" (
      "id"	INTEGER,
      "title"	TEXT NOT NULL,
      "creators"	TEXT,
      "subjects"	TEXT,
      "publisher"	TEXT,
      "publish_year"	TEXT,
      "edition"	TEXT,
      "isbn"	TEXT,
      "image"	TEXT,
      "type" TEXT,
      "language"	TEXT,
      "description"	TEXT,
      "notes"	TEXT,
      "source"	TEXT,
      "link"	TEXT,
      "path" TEXT,
      "created_at"	TEXT,
      "updated_at"	TEXT,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    ''',
    '''
    CREATE TABLE "server" (
      "id" INTEGER,
      "name" TEXT NOT NULL,
      "url" TEXT NOT NULL,
      "type" TEXT NOT NULL,
      "created_at" TEXT,
      "updated_at" TEXT,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    '''
  ];
  static const migrationScripts = [
    '''
    ALTER TABLE biblio ADD COLUMN path TEXT;
    ''',
    '''
      CREATE TABLE "server" (
        "id" INTEGER,
        "name" TEXT NOT NULL,
        "url" TEXT NOT NULL,
        "type" TEXT NOT NULL,
        "created_at" TEXT,
        "updated_at" TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    '''
  ];

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'bibliography.db');

    return await openDatabase(path, version: migrationScripts.length + 1,
        onCreate: (Database db, int version) async {
      initScript.forEach((script) async => await db.execute(script));
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
        if(migrationScripts.asMap().containsKey(i)) await db.execute(migrationScripts[i]);
      }
    });
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  // insert data
  Future<int> insert(Biblio biblio) async {
    Database database = await this.database;
    return await database.insert('biblio', biblio.toMap());
  }

  Future<int> update(Biblio biblio) async {
    Database database = await this.database;
    return await database.update('biblio', biblio.toMap(),
        where: 'id=?', whereArgs: [biblio.id]);
  }

  Future<int> delete(int id) async {
    Database database = await this.database;
    return await database.delete('biblio', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Biblio>> getBiblioList() async {
    var biblioMapList = await select();
    int count = biblioMapList.length;
    List<Biblio> biblioList = List<Biblio>();
    for (int i = 0; i < count; i++) {
      biblioList.add(Biblio.fromMap(biblioMapList[i]));
    }
    return biblioList;
  }

  Future<List<Biblio>> getBiblioSearch(String keywords) async {
    var biblioMapList = keywords != '' ? await search(keywords) : [];
    int count = biblioMapList.length;
    List<Biblio> biblioList = List<Biblio>();
    for (int i = 0; i < count; i++) {
      biblioList.add(Biblio.fromMap(biblioMapList[i]));
    }
    return biblioList;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database database = await this.database;
    return await database.query('biblio', orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> search(String keywords) async {
    Database database = await this.database;
    return await database.query('biblio',
        where: "title LIKE ?",
        whereArgs: ['%$keywords%'],
        orderBy: 'created_at DESC');
  }
}
