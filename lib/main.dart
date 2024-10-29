import 'package:flutter/material.dart';

import 'views/screens/manga_home_page.dart';

void main() {
  runApp(const MangaApp());
}

class MangaApp extends StatelessWidget {
  const MangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MangaHomePage(),
    );
  }
}