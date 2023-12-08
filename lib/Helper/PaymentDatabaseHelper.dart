import 'package:crm_flutter/Model/Payment.dart';
import 'package:crm_flutter/Model/Paymentdetails.dart';
import 'package:crm_flutter/ui/PaymentDetails.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PaymentDatabaseHelper{

  static late PaymentDatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  Database? _database;
  static final _databaseName = "CRM.db";
  static final _databaseVersion = 2;
  static final table_payment = 'paymentdetails';
  static final itemId = 'itemId';
  static final PayMode = 'PayMode';
  static final ReferenceNumber = 'RefrenceNumber';
  static final columnpayment_details = 'payment_details';
  static final PayAmount = 'PayAmount';
  static final deliveryBoyID = 'deliveryBoyID';
  static final table_delivery = 'deliverydetails';
  static final columnId = 'id';
  static final columnItem = 'item_id';
  static final columnAction = 'ActionName';

  PaymentDatabaseHelper._privateConstructor();
  static final PaymentDatabaseHelper instance = PaymentDatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    // if (_database == null)
    _database = await _initDatabase();
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
          CREATE TABLE $table_delivery (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnItem INTEGER NULL,
            $columnAction TEXT NULL)''');

    await db.execute('''
          CREATE TABLE $table_payment (
            $itemId TEXT NOT NULL,
            $PayMode TEXT NOT NULL,
            $ReferenceNumber TEXT NOT NULL, $PayAmount TEXT NOT NULL,$deliveryBoyID TEXT NOT NULL)''');

  }

  /*add to payment data*/
  Future<int> insert_payment(Paymentdetails payment) async {
    Database? db = await instance.database;
    return await db!.insert(table_payment, {'itemId': payment.itemId,'PayMode':payment.PayMode, 'PayAmount': payment.PayAmount,'ReferenceNumber': payment.RefrenceNumber,'deliveryBoyID':payment.deliveryBoyID});
  }

  /*add to delivery data*/
  Future<int> insert(Payment payment) async {
    Database? db = await instance.database;
    return await db!.insert(table_delivery, {'item_id': payment.item_id, 'ActionName': payment.action});
  }

  /* get data of delivery*/
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table_delivery);
  }

  /* get data of payment*/
  Future<List<Map<String, dynamic>>> queryAllRowspayment() async {
    Database? db = await instance.database;
    return await db!.query(table_payment);
  }

  /*count of delivery data*/
  Future<int?> queryRowCountDelivery() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table_delivery'));
  }

  /*count of payment data*/
  Future<int?> queryRowCountPayment() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table_payment'));
  }

  // /*delete all delivery*/
  // Future<int> deletedelivery(int id) async {
  //   Database? db = await instance.database;
  //   return await db.delete(table_delivery, where: '$columnId = ?', whereArgs: [id]);
  // }
  //
  // /*delete all payment*/
  // Future<int> deletepayment(int id) async {
  //   Database? db = await instance.database;
  //   return await db!.execSQL("delete from "+ table_payment);
  // }

}