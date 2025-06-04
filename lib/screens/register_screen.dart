import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/utils/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                    Text('Registrasi Perpustakaan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF306944))),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Color(0xFF4a4a4a)), border: OutlineInputBorder(), prefixIcon: Icon(Icons.person, color: Color(0xFF306944))),
                      validator: (value) => value!.isEmpty ? 'Masukkan username' : null,
                    ),
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(labelText: 'Konfirmasi Password', labelStyle: TextStyle(color: Color(0xFF4a4a4a)), border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock, color: Color(0xFF306944))),
                      obscureText: true,
                      validator: (value) => value != _passwordController.text ? 'Password tidak cocok' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944), minimumSize: Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await DatabaseHelper.insertUser(_usernameController.text, _emailController.text, _passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrasi Berhasil! Silakan login.'), backgroundColor: Color(0xFF306944), duration: Duration(seconds: 2)));
                            Navigator.pushReplacementNamed(context, '/login');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrasi Gagal: $e'), backgroundColor: Colors.red));
                          }
                        }
                      },
                      child: Text('Daftar', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun? ', style: TextStyle(color: Color(0xFF4a4a4a))),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text('Masuk di sini', style: TextStyle(color: Color(0xFF306944), fontWeight: FontWeight.bold)),
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}