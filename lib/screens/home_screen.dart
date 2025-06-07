import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan_digital/screens/book_detail_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _books = [];
  List<String> _history = []; // Menyimpan history sementara
  String _searchQuery = ''; // Untuk menyimpan input pencarian
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _fetchBooks();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'history_database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE history (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT UNIQUE)',
        );
      },
    );
    await _loadHistory();
  }

  Future<void> _fetchBooks() async {
    try {
      // Fetch fiction books
      final fictionResponse = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:fiction&maxResults=20'));
      // Fetch education books
      final educationResponse = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:education&maxResults=20'));

      if (fictionResponse.statusCode == 200 && educationResponse.statusCode == 200) {
        final fictionBooks = json.decode(fictionResponse.body)['items'] ?? [];
        final educationBooks = json.decode(educationResponse.body)['items'] ?? [];
        setState(() {
          _books = [...fictionBooks, ...educationBooks];
        });
      } else {
        print('Failed to load books: ${fictionResponse.statusCode} or ${educationResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  Future<void> _addToHistory(String title) async {
    if (_database == null) return;
    await _database!.insert(
      'history',
      {'title': title},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _loadHistory();
    setState(() {});
  }

  Future<void> _loadHistory() async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps = await _database!.query('history', orderBy: 'id DESC', limit: 5);
    setState(() {
      _history = maps.map((map) => map['title'] as String).toList();
    });
  }

  List<dynamic> _filterBooks(String query) {
    if (query.isEmpty) return _books;
    return _books.where((book) {
      final title = book['volumeInfo']['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _filterBooks(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('PERPUSTAKAAN', style: TextStyle(color: Color(0xFF306944))),
          ],
        ),
        backgroundColor: Color(0xFF95bfa4),
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
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF306944)),
              title: Text('Setting', style: TextStyle(color: Color(0xFF306944))),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Mengatur ukuran sesuai konten
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari buku...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Container(
              color: Color(0xFF95bfa4),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Reading', style: TextStyle(color: Color(0xFF306944), fontSize: 18)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _books.map((book) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _addToHistory(book['volumeInfo']['title'] ?? 'No Title');
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
                ],
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
            // Menggunakan Container untuk membungkus konten dengan tinggi dinamis
            Container(
              child: _selectedIndex == 0
                  ? _buildBookGrid(filteredBooks)
                  : _selectedIndex == 1
                  ? _buildCategoryView()
                  : _buildHistoryView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookGrid(List<dynamic> books) => GridView.builder(
    shrinkWrap: true, // Membuat GridView mengikuti ukuran konten
    physics: NeverScrollableScrollPhysics(), // Biarkan parent (SingleChildScrollView) yang scroll
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
    ),
    itemCount: books.length,
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          _addToHistory(books[index]['volumeInfo']['title'] ?? 'No Title');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(
                title: books[index]['volumeInfo']['title'] ?? 'No Title',
                coverUrl: books[index]['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                content: books[index]['volumeInfo']['description'] ?? 'no description available',
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                books[index]['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
              SizedBox(height: 4),
              Text(
                books[index]['volumeInfo']['title'] ?? 'JUDUL BUKU',
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
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BUKU NOVEL', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _books.where((book) => book['volumeInfo']['categories']?.contains('Fiction') ?? false).length,
                  itemBuilder: (context, index) {
                    final book = _books.where((book) => book['volumeInfo']['categories']?.contains('Fiction') ?? false).toList()[index];
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          _addToHistory(book['volumeInfo']['title'] ?? 'No Title');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(
                                title: book['volumeInfo']['title'] ?? 'No Title',
                                coverUrl: book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                                content: book['volumeInfo']['description'] ?? 'no description available',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BUKU PENDIDIKAN', style: TextStyle(fontSize: 20, color: Color(0xFF306944))),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _books.where((book) => book['volumeInfo']['categories']?.contains('Education') ?? false).length,
                  itemBuilder: (context, index) {
                    final book = _books.where((book) => book['volumeInfo']['categories']?.contains('Education') ?? false).toList()[index];
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          _addToHistory(book['volumeInfo']['title'] ?? 'No Title');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(
                                title: book['volumeInfo']['title'] ?? 'No Title',
                                coverUrl: book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                                content: book['volumeInfo']['description'] ?? 'no description available',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildHistoryView() => ListView.builder(
    shrinkWrap: true, // Mengikuti ukuran konten
    physics: NeverScrollableScrollPhysics(), // Biarkan parent (SingleChildScrollView) yang scroll
    itemCount: _history.length,
    itemBuilder: (context, index) {
      final title = _history[index];
      return ListTile(
        leading: Icon(Icons.book, color: Color(0xFF306944)),
        title: Text(title),
        trailing: ElevatedButton(
          child: Text('Lanjut Baca'),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF306944)),
          onPressed: () {
            final book = _books.firstWhere(
                  (b) => b['volumeInfo']['title'] == title,
              orElse: () => null,
            );
            if (book != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                    title: book['volumeInfo']['title'] ?? 'No Title',
                    coverUrl: book['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/100',
                    content: book['volumeInfo']['description'] ?? 'no description available',
                  ),
                ),
              );
            }
          },
        ),
      );
    },
  );
}