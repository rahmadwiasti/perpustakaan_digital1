import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/screens/register_screen.dart'; // Impor RegisterScreen

class SplashScreen extends StatefulWidget { // Ubah menjadi StatefulWidget
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunda selama 5 detik, lalu pindah ke RegisterScreen
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF95bfa4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 100, color: Color(0xFF306944)),
            SizedBox(height: 20),
            Text(
              'PERPUSTAKAAN',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF306944),
              ),
            ),
          ],
        ),
      ),
    );
  }
}