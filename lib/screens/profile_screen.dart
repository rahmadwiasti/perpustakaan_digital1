import 'package:flutter/material.dart';
import 'package:perpustakaan_digital/utils/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'Loading...';
  String _email = 'Loading...';
  String _profileImageUrl = 'https://via.placeholder.com/150'; // Default gambar
  final _newPasswordController = TextEditingController();
  final _passwordController = TextEditingController(); // Untuk validasi hapus akun

  // Daftar gambar hewan untuk karakter
  final List<Map<String, String>> _animalOptions = [
    {'name': 'Bebek', 'url': 'https://i.pinimg.com/736x/35/3f/d2/353fd23a1e1ed1a6613a5f929e7a447f.jpg'},
    {'name': 'Babi', 'url': 'https://i.pinimg.com/736x/dc/0b/5b/dc0b5b1dbc5466d79b97487a3db4c298.jpg'},
    {'name': 'Sapi', 'url': 'https://i.pinimg.com/736x/60/86/01/608601e24a4134672dc5ce32749b8d9c.jpg'},
    {'name': 'Dino', 'url': 'https://i.pinimg.com/736x/18/c8/bb/18c8bb1356bc59480791470657042443.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final dbHelper = DatabaseHelper.instance;
    final user = await dbHelper.getUser();
    if (user != null && mounted) {
      setState(() {
        _username = user['username'] ?? 'Unknown';
        _email = user['email'] ?? 'Unknown';
      });
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    final dbHelper = DatabaseHelper.instance;
    try {
      final user = await dbHelper.getUser();
      if (user != null) {
        await dbHelper.updateUser(user['email']!, {'password': newPassword}); // Hashing dilakukan di updateUser
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password berhasil diubah')),
        );
        _newPasswordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate password: $e')),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Akun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Apakah Anda yakin ingin menghapus akun?'),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Masukkan Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () {
              Navigator.pop(context);
              _passwordController.clear();
            },
          ),
          TextButton(
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final dbHelper = DatabaseHelper.instance;
              final user = await dbHelper.getUser();
              if (user != null) {
                final email = user['email'];
                final verifyResult = await dbHelper.verifyUser(email!, _passwordController.text);
                if (verifyResult['status'] == 'success') {
                  await dbHelper.deleteUser();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Akun berhasil dihapus')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password salah')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Akun tidak ditemukan')),
                );
              }
              _passwordController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () {
              Navigator.pop(context);
              _newPasswordController.clear();
            },
          ),
          TextButton(
            child: Text('Simpan', style: TextStyle(color: Color(0xFF306944))),
            onPressed: () {
              if (_newPasswordController.text.length >= 6) {
                _updatePassword(_newPasswordController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password minimal 6 karakter')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Color(0xFF306944))),
        backgroundColor: Color(0xFF95bfa4),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_profileImageUrl),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  _showAnimalSelectionDialog();
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Username: $_username', style: TextStyle(fontSize: 18, color: Color(0xFF4a4a4a))),
            Text('Email: $_email', style: TextStyle(fontSize: 18, color: Color(0xFF4a4a4a))),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
              onPressed: _showChangePasswordDialog,
              child: Text('Ubah Password', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _showDeleteAccountDialog,
              child: Text('Hapus Akun', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout berhasil')),
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnimalSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Karakter'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: _animalOptions.length,
            itemBuilder: (context, index) {
              final animal = _animalOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _profileImageUrl = animal['url']!;
                  });
                  Navigator.pop(context);
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(animal['url']!, height: 60, fit: BoxFit.cover),
                      SizedBox(height: 8),
                      Text(animal['name']!, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Tutup'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}