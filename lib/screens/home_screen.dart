import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan_digital/screens/profile_screen.dart';
import 'package:perpustakaan_digital/screens/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _books = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:fiction&maxResults=20'));
      if (response.statusCode == 200) {
        setState(() {
          _books = json.decode(response.body)['items'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat buku: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PERPUSTAKAAN', style: TextStyle(color: Color(0xFF306944))),
        backgroundColor: Color(0xFF95bfa4),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF306944)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF95bfa4)),
              child: Text('Menu', style: TextStyle(color: Color(0xFF306944), fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF306944)),
              title: Text('Profile', style: TextStyle(color: Color(0xFF4a4a4a))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF306944)),
              title: Text('Setting', style: TextStyle(color: Color(0xFF4a4a4a))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF95bfa4),
            padding: EdgeInsets.all(10),
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF306944)))
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _books.map((book) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      book['volumeInfo']?['imageLinks']?['thumbnail'] != null
                          ? Image.network(
                        book['volumeInfo']['imageLinks']['thumbnail'],
                        height: 100,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Color(0xFF4a4a4a)),
                      )
                          : Icon(Icons.book, color: Color(0xFF4a4a4a)),
                      SizedBox(height: 8),
                      Text(
                        book['volumeInfo']['title'] ?? 'JUDUL BUKU',
                        style: TextStyle(color: Color(0xFF4a4a4a)),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
                onPressed: () => setState(() => _selectedIndex = 0),
                child: Text('Daftar Buku', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
                onPressed: () => setState(() => _selectedIndex = 1),
                child: Text('Jenis Buku', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
                onPressed: () => setState(() => _selectedIndex = 2),
                child: Text('Riwayat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF306944)))
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
                : _selectedIndex == 0
                ? _buildBookGrid()
                : _selectedIndex == 1
                ? _buildCategoryView()
                : _buildHistoryView(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGrid() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: _books.length,
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _books[index]['volumeInfo']?['imageLinks']?['thumbnail'] != null
              ? Image.network(
            _books[index]['volumeInfo']['imageLinks']['thumbnail'],
            height: 100,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Color(0xFF4a4a4a)),
          )
              : Icon(Icons.book, color: Color(0xFF4a4a4a)),
          SizedBox(height: 8),
          Text(
            _books[index]['volumeInfo']['title'] ?? 'JUDUL BUKU',
            style: TextStyle(color: Color(0xFF4a4a4a)),
          ),
        ],
      ),
    ),
  );

  Widget _buildCategoryView() => Column(
    children: [
      Text('BUKU NOVEL', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
      Expanded(child: _buildBookGrid()),
      Text('BUKU PENDIDIKAN', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
      Expanded(child: _buildBookGrid()),
    ],
  );

  Widget _buildHistoryView() => ListView.builder(
    itemCount: _books.length,
    itemBuilder: (context, index) => ListTile(
      leading: _books[index]['volumeInfo']?['imageLinks']?['thumbnail'] != null
          ? Image.network(
        _books[index]['volumeInfo']['imageLinks']['thumbnail'],
        width: 50,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Color(0xFF4a4a4a)),
      )
          : Icon(Icons.book, color: Color(0xFF4a4a4a)),
      title: Text(_books[index]['volumeInfo']['title'] ?? 'JUDUL BUKU', style: TextStyle(color: Color(0xFF4a4a4a))),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
        child: Text('Lanjut Baca', style: TextStyle(color: Colors.white)),
        onPressed: () {},
      ),
    ),
  );
}