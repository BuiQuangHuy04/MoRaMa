import 'package:flutter/material.dart';
import 'package:morama/core/my_color.dart';

class MangaProfileWidget extends StatefulWidget {
  const MangaProfileWidget({super.key});

  @override
  State<MangaProfileWidget> createState() => _MangaProfileWidgetState();
}

class _MangaProfileWidgetState extends State<MangaProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: MyColor.scaffoldBackground,
        foregroundColor: MyColor.scaffoldForegroundColor,
        elevation: 0,
        title: const Text("PROFILE"),
        centerTitle: true,
        actions: [],
      ),
      body: const Center(
        child: Text('On Development'),
      ),
    );
  }
}
