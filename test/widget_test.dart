import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perpustakaan_digital/main.dart';
import 'package:perpustakaan_digital/screens/splash_screen.dart'; // Impor SplashScreen

void main() {
  testWidgets('SplashScreen displays correctly', (WidgetTester tester) async {
    // Render SplashScreen tanpa const
    await tester.pumpWidget(MaterialApp(home: SplashScreen()));

    // Verifikasi bahwa teks 'PERPUSTAKAAN' ditampilkan
    expect(find.text('PERPUSTAKAAN'), findsOneWidget);

    // Verifikasi bahwa ikon library_books ditampilkan
    expect(find.byIcon(Icons.library_books), findsOneWidget);
  });
}