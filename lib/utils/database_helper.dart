import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static const String _boxName = 'usersBox';
  static late Box<Map> _usersBox;

  // Inisialisasi Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_boxName)) {
      _usersBox = await Hive.openBox<Map>(_boxName);
    } else {
      _usersBox = Hive.box<Map>(_boxName);
    }
  }

  // Simpan pengguna baru
  static Future<void> insertUser(String username, String email, String password) async {
    final user = {
      'username': username,
      'email': email,
      'password': password,
    };
    await _usersBox.add(user);
  }

  // Verifikasi pengguna
  static Future<bool> verifyUser(String email, String password) async {
    final users = _usersBox.values.where((user) =>
    user['email'] == email && user['password'] == password);
    return users.isNotEmpty;
  }

  // Bersihkan data (opsional, untuk testing)
  static Future<void> clear() async {
    await _usersBox.clear();
  }
}