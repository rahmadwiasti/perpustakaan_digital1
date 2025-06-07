import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notifications = true;
  double _fontSize = 16.0;
  String _language = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Color(0xFF306944))),
        backgroundColor: Color(0xFF95bfa4),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Pengaturan Umum', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
            SwitchListTile(
              title: Text('Notifikasi', style: TextStyle(color: Color(0xFF4a4a4a), fontSize: _fontSize)),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              activeColor: Color(0xFF306944),
            ),
            ListTile(
              title: Text('Ukuran Font', style: TextStyle(color: Color(0xFF4a4a4a), fontSize: _fontSize)),
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
              title: Text('Bahasa', style: TextStyle(color: Color(0xFF4a4a4a), fontSize: _fontSize)),
              subtitle: Text(_language, style: TextStyle(color: Color(0xFF4a4a4a), fontSize: _fontSize)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Pilih Bahasa', style: TextStyle(fontSize: _fontSize)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Indonesia', style: TextStyle(fontSize: _fontSize)),
                          onTap: () {
                            setState(() => _language = 'Indonesia');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('English', style: TextStyle(fontSize: _fontSize)),
                          onTap: () {
                            setState(() => _language = 'English');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF306944),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pengaturan Disimpan', style: TextStyle(fontSize: _fontSize))),
                );
              },
              child: Text('Simpan', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
            ),
          ],
        ),
      ),
    );
  }
}