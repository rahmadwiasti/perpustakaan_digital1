import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan_digital/screens/book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:fiction&maxResults=20'));
      if (response.statusCode == 200) {
        setState(() {
          _books = json.decode(response.body)['items'] ?? [];
        });
      } else {
        print('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
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
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF95bfa4),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color(0xFF306944),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF306944)),
              title: Text('Profile', style: TextStyle(color: Color(0xFF306944))),
              onTap: () {
                // Navigasi ke halaman profile (tambahkan route jika ada)
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF306944)),
              title: Text('Setting', style: TextStyle(color: Color(0xFF306944))),
              onTap: () {
                // Navigasi ke halaman setting (tambahkan route jika ada)
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF95bfa4),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _books.map((book) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(
                              title: book['volumeInfo']['title'] ?? 'No Title',
                              coverUrl: book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                              content: book['volumeInfo']['description'] ?? 'No description available',
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.network(
                            book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                          SizedBox(height: 4),
                          Text(
                            book['volumeInfo']['title'] ?? 'JUDUL BUKU',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedIndex = 0),
                    child: Text('Daftar Buku'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 0 ? Color(0xFF306944) : Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    child: Text('Jenis Buku'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 1 ? Color(0xFF306944) : Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedIndex = 2),
                    child: Text('Riwayat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 2 ? Color(0xFF306944) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 400, // Batas tinggi untuk mencegah overflow
              child: _selectedIndex == 0
                  ? _buildBookGrid()
                  : _selectedIndex == 1
                  ? _buildCategoryView()
                  : _buildHistoryView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookGrid() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
    ),
    itemCount: _books.length,
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(
                title: _books[index]['volumeInfo']['title'] ?? 'No Title',
                coverUrl: _books[index]['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                content: _books[index]['volumeInfo']['description'] ?? 'No description available',
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                _books[index]['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
              SizedBox(height: 4),
              Text(
                _books[index]['volumeInfo']['title'] ?? 'JUDUL BUKU',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildCategoryView() => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BUKU NOVEL', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
        _buildBookGrid(),
        Text('BUKU PENDIDIKAN', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
        _buildBookGrid(),
      ],
    ),
  );

  Widget _buildHistoryView() => ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: _books.length,
    itemBuilder: (context, index) => ListTile(
      leading: Image.network(
        _books[index]['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      ),
      title: Text(_books[index]['volumeInfo']['title'] ?? 'JUDUL BUKU'),
      trailing: ElevatedButton(
        child: Text('Lanjut Baca'),
        onPressed: () {
          // Navigasi ke halaman baca (tambahkan route jika ada)
        },
      ),
    ),
  );
}