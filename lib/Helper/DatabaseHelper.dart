import 'package:crm_flutter/Model/Payment.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static late DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  Database? _database;

  static final _databaseName = "CRM.db";
  static final _databaseVersion = 1;
  static final table = 'deliverydetails';
  static final columnId = 'id';
  static final columnItem = 'item_id';
  static final columnAction = 'ActionName';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
   // if (_database == null)
      _database = await _initDatabase();
    // lazily instantiate the db the first time it is accessed

    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnItem INTEGER NULL,
            $columnAction TEXT NULL)''');
  }

  Future<int> insert(Payment payment) async {
    Database? db = await instance.database;
    return await db!.insert(table, {'item_id': payment.item_id, 'ActionName': payment.action});
  }

}