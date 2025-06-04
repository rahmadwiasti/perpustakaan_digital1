import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/screens/login_screen.dart';
import 'package:perpustakaan_digital/screens/register_screen.dart';
import 'package:perpustakaan_digital/screens/home_screen.dart'; // Pastikan impor ini ada
import 'package:perpustakaan_digital/screens/splash_screen.dart';
import 'package:perpustakaan_digital/utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}