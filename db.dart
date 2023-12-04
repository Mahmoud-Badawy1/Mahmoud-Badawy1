import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_USERS = 'users';
  static const String COLUMN_USER_ID = 'id';
  static const String COLUMN_USER_FIRST_NAME = 'first_name';
  static const String COLUMN_USER_LAST_NAME = 'last_name';
  static const String COLUMN_USER_EMAIL = 'email';
  static const String COLUMN_USER_PASSWORD = 'password';

  static const String TABLE_PRODUCTS = 'products';
  static const String COLUMN_PRODUCT_ID = 'id';
  static const String COLUMN_PRODUCT_NAME = 'name';
  static const String COLUMN_PRODUCT_PRICE = 'price';
  static const String COLUMN_PRODUCT_IMAGE = 'image';

  static const String TABLE_ORDERS = 'orders';
  static const String COLUMN_ORDER_USER_ID = 'uid';
  static const String COLUMN_ORDER_PRODUCT_ID = 'pid';
  static const String COLUMN_ORDER_CREATED_AT = 'created_at';

  static const String _databaseName = "app_database.db";
  static const int _databaseVersion = 1;
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute("""
          CREATE TABLE $TABLE_USERS (
            $COLUMN_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_USER_FIRST_NAME TEXT,
            $COLUMN_USER_LAST_NAME TEXT,
            $COLUMN_USER_EMAIL TEXT UNIQUE,
            $COLUMN_USER_PASSWORD TEXT
          );
        """);
        await db.execute("""
          CREATE TABLE $TABLE_PRODUCTS (
            $COLUMN_PRODUCT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_PRODUCT_NAME TEXT,
            $COLUMN_PRODUCT_PRICE REAL,
            $COLUMN_PRODUCT_IMAGE TEXT
          );
        """);
        await db.execute("""
          CREATE TABLE $TABLE_ORDERS (
            $COLUMN_ORDER_USER_ID INTEGER,
            $COLUMN_ORDER_PRODUCT_ID INTEGER,
            $COLUMN_ORDER_CREATED_AT TEXT,
            PRIMARY KEY ($COLUMN_ORDER_USER_ID, $COLUMN_ORDER_PRODUCT_ID),
            FOREIGN KEY ($COLUMN_ORDER_USER_ID) REFERENCES $TABLE_USERS ($COLUMN_USER_ID),
            FOREIGN KEY ($COLUMN_ORDER_PRODUCT_ID) REFERENCES $TABLE_PRODUCTS ($COLUMN_PRODUCT_ID)
          );
        """);
      },
    );
  }

  Future<void> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      TABLE_USERS,
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_USERS,
      where: "$COLUMN_USER_EMAIL = ? AND $COLUMN_USER_PASSWORD = ?",
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> insertProduct(Map<String, dynamic> productData) async {
    final db = await database;
    await db.insert(
      TABLE_PRODUCTS,
      productData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query(TABLE_PRODUCTS);
  }

  Future<void> insertOrder(Map<String, dynamic> orderData) async {
    final db = await database;
    await db.insert(
      TABLE_ORDERS,
      orderData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOrdersByUserId(int userId) async {
    final db = await database;
    return await db.query(
      TABLE_ORDERS,
      where: "$COLUMN_ORDER_USER_ID = ?",
      whereArgs: [userId],
    );
  }
}
