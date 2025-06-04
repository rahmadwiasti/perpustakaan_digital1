import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'User123';
  String _email = 'user@example.com';
  String _profileImageUrl = 'https://via.placeholder.com/150'; // URL placeholder untuk foto profil
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Color(0xFF306944))),
        backgroundColor: Color(0xFF95bfa4),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_profileImageUrl),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _profileImageUrl = 'https://via.placeholder.com/150?new'; // Contoh perubahan
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Username: $_username', style: TextStyle(fontSize: 18, color: Color(0xFF4a4a4a))),
            Text('Email: $_email', style: TextStyle(fontSize: 18, color: Color(0xFF4a4a4a))),
            SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)), // Ganti primary dengan backgroundColor
              onPressed: () {
                setState(() {
                  // Simulasi perubahan password
                });
              },
              child: Text('Ubah Password', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Ganti primary dengan backgroundColor
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Hapus Akun'),
                    content: Text('Apakah Anda yakin ingin menghapus akun?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
                      TextButton(onPressed: () {
                        // Logika hapus akun
                        Navigator.pop(context);
                      }, child: Text('Hapus')),
                    ],
                  ),
                );
              },
              child: Text('Hapus Akun', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)), // Ganti primary dengan backgroundColor
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman login
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}