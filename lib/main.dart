import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/screens/splash_screen.dart';
import 'package:perpustakaan_digital/screens/login_screen.dart';
import 'package:perpustakaan_digital/screens/register_screen.dart';
import 'package:perpustakaan_digital/screens/home_screen.dart';
import 'package:perpustakaan_digital/screens/book_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/book-detail': (context) => BookDetailScreen(
          title: '',
          coverUrl: '',
          content: '',
        ),
      },
    );
  }
}