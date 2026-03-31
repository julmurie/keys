import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/test_page.dart';
import 'pages/history_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const KeysApp());
}

class KeysApp extends StatelessWidget {
  const KeysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KEYS',
      theme: ThemeData(textTheme: GoogleFonts.figtreeTextTheme()),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/test': (context) => const TestPage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}
