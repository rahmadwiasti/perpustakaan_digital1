import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/utils/database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Color(0xFF95bfa4),
                child: Column(
                  children: [
                    Icon(Icons.library_books, size: 100, color: Color(0xFF306944)),
                    SizedBox(height: 16),
                    Text('Masuk ke Perpustakaan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF306944))),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Color(0xFF4a4a4a)), border: OutlineInputBorder(), prefixIcon: Icon(Icons.email, color: Color(0xFF306944))),
                      validator: (value) => value!.isEmpty ? 'Masukkan email' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Color(0xFF4a4a4a)), border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock, color: Color(0xFF306944))),
                      obscureText: true,
                      validator: (value) => value!.isEmpty ? 'Masukkan password' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944), minimumSize: Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool isAuthenticated = await DatabaseHelper.verifyUser(_emailController.text, _passwordController.text);
                          if (isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Berhasil!'), backgroundColor: Color(0xFF306944), duration: Duration(seconds: 2)));
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email atau Password Salah'), backgroundColor: Colors.red));
                          }
                        }
                      },
                      child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun? ', style: TextStyle(color: Color(0xFF4a4a4a))),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: Text('Daftar di sini', style: TextStyle(color: Color(0xFF306944), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}