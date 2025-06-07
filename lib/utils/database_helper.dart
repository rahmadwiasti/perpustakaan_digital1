import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    print('Database path: $path'); // Debugging path database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await database;

    // Hash password sebelum menyimpan
    if (user['password'] != null) {
      user['password'] = _hashPassword(user['password']);
    }

    // Cek apakah email sudah ada
    List<Map<String, dynamic>> existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user['email']],
    );

    if (existing.isEmpty) {
      await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      throw Exception('Email sudah terdaftar');
    }
  }

  Future<Map<String, String>> verifyUser(String email, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    // Cek apakah email ada
    List<Map<String, dynamic>> emailResult = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (emailResult.isEmpty) {
      return {'status': 'not_registered', 'message': 'Akun belum terdaftar'};
    }

    // Cek apakah password cocok
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (result.isNotEmpty) {
      return {'status': 'success', 'message': 'Login berhasil'};
    } else {
      return {'status': 'wrong_credentials', 'message': 'Email atau password salah'};
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users');
    print('All users: $result'); // Debugging
    return result;
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('users');
  }

  Future<void> updateUser(String email, Map<String, dynamic> updates) async {
    final db = await database;
    try {
      // Hash password jika ada di updates
      if (updates['password'] != null) {
        updates['password'] = _hashPassword(updates['password']);
      }

      // Pastikan email tidak diubah (karena unique constraint)
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existingUser.isNotEmpty) {
        await db.update(
          'users',
          updates,
          where: 'email = ?',
          whereArgs: [email],
        );
      } else {
        throw Exception('Pengguna dengan email $email tidak ditemukan');
      }
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Gagal mengupdate pengguna: $e');
    }
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}