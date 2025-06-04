import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notifications = true;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Color(0xFF306944))),
        backgroundColor: Color(0xFF95bfa4),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan Umum', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
            SwitchListTile(
              title: Text('Notifikasi', style: TextStyle(color: Color(0xFF4a4a4a))),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              activeColor: Color(0xFF306944),
            ),
            ListTile(
              title: Text('Ukuran Font', style: TextStyle(color: Color(0xFF4a4a4a))),
              subtitle: Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
                activeColor: Color(0xFF306944),
              ),
            ),
            ListTile(
              title: Text('Bahasa', style: TextStyle(color: Color(0xFF4a4a4a))),
              subtitle: Text('Indonesia', style: TextStyle(color: Color(0xFF4a4a4a))),
              onTap: () {
                // Logika untuk mengganti bahasa
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)), // Ganti primary dengan backgroundColor
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pengaturan Disimpan')));
              },
              child: Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}