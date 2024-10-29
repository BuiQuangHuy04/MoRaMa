import 'package:flutter/material.dart';

class MangaBookmarkWidget extends StatefulWidget {
  const MangaBookmarkWidget({super.key});

  @override
  State<MangaBookmarkWidget> createState() => _MangaBookmarkWidgetState();
}

class _MangaBookmarkWidgetState extends State<MangaBookmarkWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("BOOKMARK"),
        centerTitle: true,
        actions: [],
      ),
      body: const Center(child: Text('On Development'),),
    );
  }
}
