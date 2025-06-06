import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/utils/database_helper.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() {
    Timer(Duration(seconds: 5), () async {
      try {
        final dbHelper = DatabaseHelper.instance; // Gunakan instance singleton
        final user = await dbHelper.getUser();

        if (!mounted) return; // Pastikan widget masih ada sebelum navigasi

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        print('Splash screen error: $e');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login'); // Fallback ke login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books,
              size: 100,
              color: Color(0xFF306944),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              color: Color(0xFF306944),
            ),
          ],
        ),
      ),
    );
  }
}