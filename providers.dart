import 'package:flutter/material.dart';
import 'db.dart';

class UserProvider with ChangeNotifier {
  String? _firstName;
  String? _lastName;
  int? _userId;
  late DatabaseProvider _databaseProvider;

  UserProvider(this._databaseProvider);
  set databaseProvider(DatabaseProvider databaseProvider) {
    _databaseProvider = databaseProvider;
    // Notify listeners if the update should trigger UI changes
    notifyListeners();
  }

  // Getter for full name
  String get fullName => "$_firstName $_lastName";

  // Getter for user ID
  int? get userId => _userId;

  // Method to initialize the user's information
  void setUser(String firstName, String lastName, int userId) {
    _firstName = firstName;
    _lastName = lastName;
    _userId = userId;
    notifyListeners();
  }

  // Method to sign up a new user
  Future<void> signUp(
      String firstName, String lastName, String email, String password) async {
    final hashedPassword = _hashPassword(password); // Implement proper hashing

    final Map<String, dynamic> userData = {
      DatabaseProvider.COLUMN_USER_FIRST_NAME: firstName,
      DatabaseProvider.COLUMN_USER_LAST_NAME: lastName,
      DatabaseProvider.COLUMN_USER_EMAIL: email,
      DatabaseProvider.COLUMN_USER_PASSWORD: hashedPassword,
    };

    // Insert the user into the database
    await _databaseProvider.insertUser(userData);

    // Optionally set the user info in the provider
    final newUser = await _databaseProvider.getUserByEmailAndPassword(
        email, hashedPassword);
    if (newUser != null) {
      setUser(
          newUser[DatabaseProvider.COLUMN_USER_FIRST_NAME],
          newUser[DatabaseProvider.COLUMN_USER_LAST_NAME],
          newUser[DatabaseProvider.COLUMN_USER_ID]);
    }
  }

  // Method to log in a user
  Future<bool> login(String email, String password) async {
    final hashedPassword = _hashPassword(password); // Implement proper hashing

    final user = await _databaseProvider.getUserByEmailAndPassword(
        email, hashedPassword);
    if (user != null) {
      setUser(
          user[DatabaseProvider.COLUMN_USER_FIRST_NAME],
          user[DatabaseProvider.COLUMN_USER_LAST_NAME],
          user[DatabaseProvider.COLUMN_USER_ID]);
      return true;
    }
    return false;
  }

  // Method to log out the current user
  Future<void> logout() async {
    _firstName = null;
    _lastName = null;
    _userId = null;
    notifyListeners();
  }

  // Method to hash a password (placeholder, replace with actual hashing)
  String _hashPassword(String password) {
    // TODO: Implement actual hashing logic
    return password;
  }

  // Method to update the user's information
  // Future<void> updateUserInformation(Map<String, dynamic> newUserData) async {
  //   // Update the user in the database
  //   await databaseProvider.updateUserInformation(_userId!, newUserData);

  //   // Update the user info in the provider
  //   setUser(newUserData[DatabaseProvider.COLUMN_USER_FIRST_NAME], newUserData[DatabaseProvider.COLUMN_USER_LAST_NAME], _userId!);
  // }

  // Other UserProvider methods as needed...
}

//   Future<void> cancelOrder(int orderId) async {
//     final db = await databaseProvider.database;
//     await db.delete(
//       'orders',
//       where: 'id = ?',
//       whereArgs: [orderId],
//     );
//     notifyListeners();
//   }

//   Future<void> updateOrder(int orderId, Map<String, dynamic> updateData) async {
//     final db = await databaseProvider.database;
//     await db.update(
//       'orders',
//       updateData,
//       where: 'id = ?',
//       whereArgs: [orderId],
//     );
//     notifyListeners();
//   }

//   Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
//     final db = await databaseProvider.database;
//     final List<Map<String, dynamic>> orderDetails = await db.rawQuery(
//       'SELECT orders.*, products.name, products.price, products.image '
//       'FROM orders '
//       'JOIN products ON products.id = orders.pid '
//       'WHERE orders.id = ?',
//       [orderId],
//     );
//     return orderDetails.first;
//   }

//   Future<List<Map<String, dynamic>>> getOrderHistory(int userId) async {
//     final db = await databaseProvider.database;
//     final List<Map<String, dynamic>> orderHistory = await db.rawQuery(
//       'SELECT orders.*, products.name, products.price, products.image '
//       'FROM orders '
//       'JOIN products ON products.id = orders.pid '
//       'WHERE orders.uid = ? '
//       'ORDER BY orders.created_at DESC',
//       [userId],
//     );
//     return orderHistory;
//   }
// }

// class DatabaseProvider {

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDB();
//     return _database!;
//   }

//    Future<Database> initDB() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(path,
//       version: _databaseVersion,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE users (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             first_name TEXT NOT NULL,
//             last_name TEXT NOT NULL,
//             email TEXT NOT NULL UNIQUE,
//             password TEXT NOT NULL
//           );
//         ''');
//         await db.execute('''
//           CREATE TABLE products (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT NOT NULL,
//             price REAL NOT NULL,
//             image TEXT NOT NULL
//           );
//         ''');
//         await db.execute('''
//           CREATE TABLE orders (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             uid INTEGER NOT NULL,
//             pid INTEGER NOT NULL,
//             created_at DATETIME NOT NULL,
//             FOREIGN KEY (uid) REFERENCES users (id),
//             FOREIGN KEY (pid) REFERENCES products (id)
//           );
//         ''');   },
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         first_name TEXT NOT NULL,
//         last_name TEXT NOT NULL,
//         email TEXT NOT NULL UNIQUE,
//         password TEXT NOT NULL
//       );
//     ''');
//     // Create other tables if needed
//   }

//   Future<int> insertUser(Map<String, dynamic> userData) async {
//     Database db = await database;
//     return await db.insert('users', userData,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }
// }

