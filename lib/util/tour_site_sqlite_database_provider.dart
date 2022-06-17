import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/tour_site.dart';


class TourSiteSQLiteDatabaseProvider {
  static const String DATABASE_FILENAME = "tourSite_database.db";
  static const String TABLE_NAME = "tourSites";

  static final TourSiteSQLiteDatabaseProvider _databaseProvider = TourSiteSQLiteDatabaseProvider._();
  static Database? _database;

  TourSiteSQLiteDatabaseProvider._();
  static TourSiteSQLiteDatabaseProvider get getDatabaseProvider => _databaseProvider;

  Future<Database> get getDatabase async =>
    _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), DATABASE_FILENAME),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $TABLE_NAME('
            'id INTEGER PRIMARY KEY, '  // Not AUTOINCREMENT
            'title TEXT, '
            'tel TEXT, '
            'zipcode TEXT, '
            'address TEXT, '
            'mapx Number, '
            'mapy Number, '
            'imagePath TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<TourSite>> getTourSites() async {
    Database database = await getDatabase;
    final List<Map<String, dynamic>> tourSiteMapList = await database.query(TABLE_NAME);

    return List.generate(tourSiteMapList.length, (i) {
      return TourSite(
        id: tourSiteMapList[i]['id'].toString(),
        title: tourSiteMapList[i]['title'].toString(),
        tel: tourSiteMapList[i]['tel'].toString(),
        zipcode: tourSiteMapList[i]['zipcode'].toString(),
        address: tourSiteMapList[i]['address'].toString(),
        mapx: tourSiteMapList[i]['mapx'].toString(),
        mapy: tourSiteMapList[i]['mapy'].toString(),
        imagePath: tourSiteMapList[i]['imagePath'].toString(),
      );
    });
  }

  Future<void> insertTourSite(TourSite tourSite) async {
    Database database = await getDatabase;
    await database.insert(TABLE_NAME, tourSite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTourSite(TourSite tourSite) async {
    Database database = await getDatabase;
    await database.delete(TABLE_NAME,
      where: 'id = ?',
      whereArgs: [tourSite.id],
    );
  }
}